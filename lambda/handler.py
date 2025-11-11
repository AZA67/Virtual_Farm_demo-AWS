import json                       
import os                         
from datetime import datetime, timezone  

# Required by AWS for Lambda runtime
import boto3                     
from boto3.dynamodb.conditions import Key  

# Read env vars once at init (cold start)
TABLE_NAME = os.environ.get("TABLE_NAME") 
ALLOWED = os.environ.get("ALLOWED_ORIGINS", "*")
ALLOWED = [o.strip() for o in ALLOWED.split(",")] if ALLOWED else ["*"]

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(TABLE_NAME)

def cors_headers(origin: str) -> dict:
    if "*" in ALLOWED:
        allow = "*"
    elif origin in ALLOWED:
        allow = origin
    else:
        allow = ALLOWED[0] if ALLOWED else "*"

    return {
        "Access-Control-Allow-Origin": allow,
        "Access-Control-Allow-Headers": "content-type,x-user-id",
        "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
    }

def response(status: int, body: dict, origin_header: str = "") -> dict:
    headers = {"content-type": "application/json"}
    headers.update(cors_headers(origin_header))
    return {"statusCode": status, "headers": headers, "body": json.dumps(body)}

def parse_body(raw: str | None) -> dict:
    if not raw:
        return {}
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        return {}

def valid_plot_id(v) -> bool:
    return isinstance(v, int) and 0 <= v < 36

def now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()

##--Entry point for API Gateway--##
def handler(event, context):
    http = (event.get("requestContext") or {}).get("http") or {}
    method = http.get("method", "GET")                   
    raw_path = event.get("rawPath") or http.get("path") or "/" 
    headers = {k.lower(): v for k, v in (event.get("headers") or {}).items()}  
    origin = headers.get("origin", "")                   
    user_id = headers.get("x-user-id") 

    if method == "OPTIONS":
        return {"statusCode": 204, "headers": cors_headers(origin)}

    if not user_id:
        return response(400, {"error": "Missing x-user-id header"}, origin)

##--Route: GET /state--##
    if method == "GET" and raw_path.endswith("/state"):
        try:
            pk = f"USER#{user_id}"
            res = table.query(
                KeyConditionExpression=Key("pk").eq(pk) & Key("sk").begins_with("PLOT#")
            )
           
            items = [
                {"plotId": int(it["plotId"]), "crop": it["crop"], "plantedAt": it["plantedAt"]}
                for it in res.get("Items", [])
            ]
            return response(200, {"items": items}, origin)
        except Exception as e:
            print("ERROR GET /state:", repr(e))
            return response(500, {"error": "Server error"}, origin)

##--Route: POST /plant--##
    if method == "POST" and raw_path.endswith("/plant"):
        body = parse_body(event.get("body"))
        plot_id = body.get("plotId")
        crop = body.get("crop")
        if not valid_plot_id(plot_id) or not crop:
            return response(400, {"error": "plotId (0-35) and crop are required"}, origin)
        try:
            table.put_item(
                Item={
                    "pk": f"USER#{user_id}",
                    "sk": f"PLOT#{plot_id}",
                    "plotId": int(plot_id),
                    "crop": str(crop),
                    "plantedAt": now_iso(),
                }
            )
            return response(200, {"ok": True}, origin)
        except Exception as e:
            print("ERROR POST /plant:", repr(e))
            return response(500, {"error": "Server error"}, origin)

##--Route: POST /harvest--##
    if method == "POST" and raw_path.endswith("/harvest"):
        body = parse_body(event.get("body"))
        plot_id = body.get("plotId")
        if not valid_plot_id(plot_id):
            return response(400, {"error": "plotId (0-35) is required"}, origin)
        try:
            table.delete_item(
                Key={"pk": f"USER#{user_id}", "sk": f"PLOT#{plot_id}"}
            )
            return response(200, {"ok": True}, origin)
        except Exception as e:
            print("ERROR POST /harvest:", repr(e))
            return response(500, {"error": "Server error"}, origin)

    return response(404, {"error": "Not found"}, origin)

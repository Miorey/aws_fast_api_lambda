from fastapi import APIRouter, HTTPException, Response

from schemas.check_response import CheckResponse

router = APIRouter(
    tags=["Status"],
)


@router.post("/ping", response_model=CheckResponse)
async def check_http_response(check_response: CheckResponse, response: Response):
    if 400 <= check_response.http_code:
        raise HTTPException(status_code=check_response.http_code, detail=check_response.http_message)
    response.status_code = check_response.http_code
    return check_response


@router.get("/")
async def root_endpoint():
    return {"status": "OK", "message": "Et VOILA !"}


@router.get("/ping")
async def health_check():
    return {"status": "OK", "message": "Pong"}

from fastapi import Request


async def add_response_headers_middleware(request: Request, call_next):
    return await call_next(request)

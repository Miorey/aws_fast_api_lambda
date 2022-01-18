from http import HTTPStatus
from typing import Optional
from pydantic import Field
from pydantic import BaseModel


class CheckResponse(BaseModel):
    http_code: HTTPStatus = Field(...)
    http_message: Optional[str] = Field(None)

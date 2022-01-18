from pydantic import Field
from typing import List
from pydantic import BaseModel


class ErrorModel(BaseModel):
    status_code: str = Field(..., description="Error description")
    sub_status_codes: List[str] = []

from fastapi import FastAPI
from fastapi.exceptions import RequestValidationError

from config import DESCRIPTION, TITLE

from core.errors import validation_exception_handler
from routers.status import router as status_router
from mangum import Mangum

app = FastAPI(title=TITLE, description=DESCRIPTION)

app.add_exception_handler(RequestValidationError, handler=validation_exception_handler)

app.include_router(status_router)
handler = Mangum(app)

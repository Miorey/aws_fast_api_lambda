from fastapi import APIRouter, Request
from fastapi.templating import Jinja2Templates

templates = Jinja2Templates(directory="templates")


router = APIRouter(
    tags=["Status"],
)


@router.get("/style.css")
async def style_endpoint(request: Request):
    return templates.TemplateResponse("style/style.css", {"request": request})


@router.get("/")
async def root_endpoint(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

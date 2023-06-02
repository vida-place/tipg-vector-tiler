import pathlib

from starlette.templating import Jinja2Templates

# Custom code to allow loading our own templates
templates = Jinja2Templates(directory=str(pathlib.Path(__file__).parent))

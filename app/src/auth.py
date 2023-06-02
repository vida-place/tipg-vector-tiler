import os

from fastapi import HTTPException, Security
from fastapi.security.api_key import APIKeyQuery
from starlette.status import HTTP_401_UNAUTHORIZED, HTTP_403_FORBIDDEN

API_KEY_NAME = "X-API-KEY"
API_KEY = os.getenv("API_KEY")

api_key_query = APIKeyQuery(name=API_KEY_NAME, auto_error=True)


async def get_api_key(api_key_header: str = Security(api_key_query)):
    """Simple token validation"""
    if not api_key_header:
        raise HTTPException(status_code=HTTP_403_FORBIDDEN, detail="Missing API key")

    if api_key_header != API_KEY:
        raise HTTPException(status_code=HTTP_401_UNAUTHORIZED, detail="Invalid API Key")

    return True

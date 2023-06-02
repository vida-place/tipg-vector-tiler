"""Custom VIDA tipg app."""

from typing import Any, List

from auth import get_api_key
from catalog.catalog import catalog
from db import close_db_connection, connect_to_db
from dependencies import CollectionParams
from fastapi import FastAPI, Request, Security
from loguru import logger as log
from settings import APISettings, CustomSQLSettings, DatabaseSettings, PostgresSettings
from starlette.middleware.cors import CORSMiddleware
from starlette_cramjam.middleware import CompressionMiddleware
from templates.template import templates
from tipg import __version__ as tipg_version
from tipg.errors import DEFAULT_STATUS_CODES, add_exception_handlers
from tipg.factory import Endpoints
from tipg.middleware import CacheControlMiddleware

# Load settings
settings = APISettings()
postgres_settings = PostgresSettings()
db_settings = DatabaseSettings()
custom_sql_settings = CustomSQLSettings()

# Register app
app = FastAPI(
    title=settings.name,
    version=tipg_version,
    openapi_url="/api",
    docs_url="/api.html",
)

# Register endpoints
ogc_api = Endpoints(
    title=settings.name,
    templates=templates,
    with_tiles_viewer=settings.add_tiles_viewer,
    collection_dependency=CollectionParams,
)

# Register router
app.include_router(ogc_api.router, dependencies=[Security(get_api_key)])

# Set all CORS enabled origins
if settings.cors_origins:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["GET"],
        allow_headers=["*"],
    )

# Set middleware
app.add_middleware(CacheControlMiddleware, cachecontrol=settings.cachecontrol)
app.add_middleware(CompressionMiddleware)
add_exception_handlers(app, DEFAULT_STATUS_CODES)


@app.on_event("startup")
async def startup_event() -> None:
    """Connect to database on startup."""
    await connect_to_db(
        app,
        settings=postgres_settings,
        schemas=db_settings.schemas,
        user_sql_files=custom_sql_settings.sql_files,
    )
    log.info("Connection succesful")

    # We run TiPG stateless by loading a static catalog model
    app.state.collection_catalog = catalog
    log.info("Catalog registered")


@app.on_event("shutdown")
async def shutdown_event() -> None:
    """Close database connection."""
    log.info("Closing DB connection")
    await close_db_connection(app)


@app.get(
    "/healthz",
    description="Health Check.",
    summary="Health Check.",
    operation_id="healthCheck",
    tags=["Health Check"],
)
def ping():
    """Health check."""
    return {"ping": "pong!"}


if settings.debug:

    @app.get("/rawcatalog", tags=["debug"])
    async def raw_catalog(request: Request):
        """Return parsed catalog data for testing."""
        return request.app.state.collection_catalog

    @app.get("/refresh", tags=["debug"])
    async def refresh(request: Request):
        """Return parsed catalog data for testing."""
        await startup_event()
        return request.app.state.collection_catalog

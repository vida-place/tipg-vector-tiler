"""tipg dependencies."""

import re
from typing import Dict, List

from fastapi import HTTPException, Path
from starlette.requests import Request
from tipg.dbmodel import Collection


def CollectionParams(
    request: Request,
    collectionId: str = Path(..., description="Collection identifier"),
) -> Collection:
    """Return Layer Object."""

    # We enforce a run_id filter on the location table.
    if request.scope["path"].startswith("/collections/backend.location/tiles/"):
        params = dict(request.query_params)
        if not params.get("run_id"):
            raise HTTPException(
                status_code=422, detail=f"Invalid request, missing run_id filter."
            )

    collection_pattern = re.match(  # type: ignore
        r"^(?P<schema>.+)\.(?P<collection>.+)$", collectionId
    )
    if not collection_pattern:
        raise HTTPException(
            status_code=422, detail=f"Invalid Collection format '{collectionId}'."
        )

    if not collection_pattern.groupdict().keys() == {"schema", "collection"}:
        raise HTTPException(
            status_code=422,
            detail=f"Invalid key format '{collection_pattern.groupdict()}'.",
        )

    collection_catalog = getattr(request.app.state, "collection_catalog", {})
    if collectionId in collection_catalog:
        return collection_catalog[collectionId]

    raise HTTPException(
        status_code=404, detail=f"Table/Function '{collectionId}' not found."
    )

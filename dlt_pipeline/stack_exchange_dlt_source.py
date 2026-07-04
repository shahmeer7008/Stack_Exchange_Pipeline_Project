import os
import time
import logging

import dlt
from dlt.sources.helpers import requests

logger = logging.getLogger(__name__)

BASE_URL = "https://api.stackexchange.com/2.3"

MAX_PAGES = 10

RESOURCE_CONFIG = {
    "users": {
        "primary_key": "user_id",
        "cursor": "creation_date",
        "sort": "creation"
    },
    "questions": {
        "primary_key": "question_id",
        "cursor": "creation_date",
        "sort": "creation"
    },
    "answers": {
        "primary_key": "answer_id",
        "cursor": "creation_date",
        "sort": "creation"
    },
    "comments": {
        "primary_key": "comment_id",
        "cursor": "creation_date",
        "sort": "creation"
    },
    "badges": {
        "primary_key": "badge_id",
        "cursor": None,
        "sort": "rank"
    },
    "tags": {
        "primary_key": "name",
        "cursor": None,
        "sort": "popular"
    }
}


def fetch_resource(resource_name, from_date=0):
    page = 1

    while page <= MAX_PAGES:

        params = {
            "site": "stackoverflow",
            "sort": RESOURCE_CONFIG[resource_name]["sort"],
            "order": "desc",
            "pagesize": 100,
            "page": page,
        }

        if RESOURCE_CONFIG[resource_name]["cursor"]:
            params["fromdate"] = from_date

        

        response = requests.get(
            f"{BASE_URL}/{resource_name}",
            params=params
        )

        response.raise_for_status()

        data = response.json()

        items = data.get("items", [])

        logger.info(
            f"{resource_name}: page {page}, records {len(items)}"
        )

        for item in items:
            yield item

        if "backoff" in data:
            logger.info(f"Sleeping {data['backoff']} seconds...")
            time.sleep(data["backoff"])

        if not data.get("has_more", False):
            break

        page += 1


def make_resource(resource_name):
    config = RESOURCE_CONFIG[resource_name]

    if config["cursor"]:

        @dlt.resource(
            name=resource_name,
            primary_key=config["primary_key"],
            write_disposition="merge",
        )
        def resource(
            updated=dlt.sources.incremental(
                config["cursor"],
                initial_value=1698969600
            )
        ):
            yield from fetch_resource(resource_name, updated.last_value)

    else:

        @dlt.resource(
            name=resource_name,
            primary_key=config["primary_key"],
            write_disposition="merge",
        )
        def resource():
            yield from fetch_resource(resource_name)

    return resource


@dlt.source(max_table_nesting=0)
def stack_exchange_source():


    yield make_resource("users")

    yield make_resource("questions")

    yield make_resource("answers")

    yield make_resource("comments")

    yield make_resource("badges")

    yield make_resource("tags")
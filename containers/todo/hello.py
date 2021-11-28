import os
import sys
from flask import Flask
import logging


def prefix_route(route_function, prefix="", mask="{0}{1}"):
    """
    Defines a new route function with a prefix.
    The mask argument is a `format string` formatted with, in that order:
      prefix, route
    """

    def newroute(route, *args, **kwargs):
        """New function to prefix the route"""
        return route_function(mask.format(prefix, route), *args, **kwargs)

    return newroute


logger = logging.getLogger(__name__)
if os.environ.get("DEBUG") and int(os.environ.get("DEBUG")) == 1:
    logger.setLevel(logging.DEBUG)
else:
    logger.setLevel(logging.INFO)

handler = logging.StreamHandler(sys.stdout)
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)
logger.addHandler(handler)

app = Flask(__name__)


@app.route("/demo-service")
def hello_world():
    return "<p>Hello, Flask!</p>"

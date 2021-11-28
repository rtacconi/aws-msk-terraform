import os
import sys
from flask import Flask
import logging
import records
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate


logger = logging.getLogger(__name__)
if os.environ.get("DEBUG") and int(os.environ.get("DEBUG")) == 1:
    logger.setLevel(logging.DEBUG)
else:
    logger.setLevel(logging.INFO)

handler = logging.StreamHandler(sys.stdout)
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)
logger.addHandler(handler)

# DSN = f"postgresql://{os.environ['DATABASE_USERNAME']}:{os.environ['DATABASE_PASSWORD']}@{os.environ['CLUSTER_ENDPOINT']}:{os.environ['CLUSTER_PORT']}/{os.environ['DATABASE_NAME']}"
# db = records.Database(DSN)
# logger.info(DSN)
app = Flask(__name__)
app.config[
    "SQLALCHEMY_DATABASE_URI"
] = "postgresql://postgres:secret:192.168.1.192:5432/flask"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db = SQLAlchemy(app)
migrate = Migrate(app, db)


@app.route("/demo-service")
def hello_world():
    rows = db.query("SELECT 1")
    return f"<p>Hello, Flask!</p><p>SELECT 1: {rows}</p>"

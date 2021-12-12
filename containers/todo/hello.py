import os
import sys
from flask import Flask
import logging
import records


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
DSN = "postgresql://postgres:secret@192.168.1.192/postgres"
db = records.Database(DSN)
logger.info(DSN)
app = Flask(__name__)
rows = db.query("SELECT * from todos")

for r in rows:
    print(r.name)


@app.route("/demo-service")
def hello_world():
    return f"""<h1>Hello, Flask!</h1>
<ul>
{[r for rows in r]}
</ul>"""

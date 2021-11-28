#!/bin/bash -e
dbmate -u "postgres://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${CLUSTER_ENDPOINT}:5432/${DATABASE_NAME}?sslmode=disable" up

export FLASK_APP=hello
flask run --host=0.0.0.0

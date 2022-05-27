#!/bin/bash

source $VIRTUAL_ENV/bin/activate
python3 -m pip install --upgrade pip --upgrade --no-cache-dir -r requirements.txt
pytest -vv tests
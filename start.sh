#!/bin/bash
trap 'kill $(jobs -p)' EXIT
sudo python3.7 -m pipenv install
sudo python3.7 -m pipenv run uvicorn main_api:app --host=0.0.0.0 --port=5080 &
sudo python3.7 -m pipenv run python3.7 main_timer.py

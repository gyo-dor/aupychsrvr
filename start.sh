python3.7 -m pipenv run uvicorn main_api:app --host=0.0.0.0 --port=5080 &
python3.7 -m pipenv run python3.7 main_timer.py &
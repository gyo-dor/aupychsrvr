from fastapi import FastAPI
from engine import ServerEngine, Response
import os

app = FastAPI()

engine_path = os.path.join("engines", "linux", "engine")
if "nt" in os.name:
    engine_path = os.path.join("engines", "windows", "engine.exe")

engine: ServerEngine = None

# TODO Passed testing can play more than 2 games with same engine lifecycle.


@app.post("/on_initialize_engine")
def on_initialize_engine(config: dict):
    global engine
    message = ""
    
    try:
        if isinstance(engine, ServerEngine):
            message += "Detected running engine instance, but successfully terminated."
            engine.on_finish()

        engine = ServerEngine(engine_path, config)
        message += "Engine initialized."
        return Response.success(message)
    
    except Exception as e:
        return Response.error(str(e))


@app.get("/move/{notation}")
def on_move(notation: str):
    return engine.move(notation)


@app.post("/get_best_move")
def on_get_best_move(thinking_time: float):
    return engine.get_best_move(thinking_time=thinking_time)


@app.post("/get_best_move_by_clock")
def on_get_best_move_by_clock(white_clock: float, black_clock: float):
    return engine.get_best_move_by_clock(white_clock, black_clock)


@app.get("/on_finish")
def on_finish():
    return engine.on_finish()


@app.get("/overwrite_fen/{side}/{fen}")
def overwrite_fen(side: str, fen: str):
    return engine.overwrite_fen(fen, side)


@app.get("/use_this_fen/{fen}")
def use_this_fen(fen: str):
    return engine.use_this_fen(fen)


@app.get("/get_current_fen")
def get_current_fen():
    return engine.get_current_fen()
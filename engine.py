import chess
import chess.engine
import random
import os


def safe_response(func):
    def inner_function(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as e:
            return Response.error(str(e))
    return inner_function


class ServerEngine:

    def __init__(self, engine_path: str, engine_config: dict):
        """ Board and Engine instances are running on your local computer.
            Engine path is relative path into your executable engine.
        """
        self.engine_path = engine_path
        self.engine_config = engine_config
        self.board = chess.Board()
        self.engine_instance = None
        self.initialize_engine()

    def initialize_engine(self):
        if self.engine_instance is not None:
            self.engine_instance.close()
            self.engine_instance = None
        self.engine_instance = chess.engine.SimpleEngine.popen_uci(self.engine_path)
        self.engine_instance.configure(self.engine_config)

    @safe_response
    def get_current_fen(self):
        return Response.fen(str(self.board.fen()))

    @safe_response
    def overwrite_fen(self, fen, side):
        fen_status = str(self.board.fen()).split(" ")[1:]
        new_fen = fen + " " + " ".join(fen_status)
        if side == "white":
            new_fen = new_fen.replace(" b ", " w ")
        else:
            new_fen = new_fen.replace(" w ", " b ")
        self.board = chess.Board(new_fen)
        return Response.success(f"Overwrite FEN success. Current active FEN: [{str(self.board.fen())}]")

    @safe_response
    def use_this_fen(self, fen):
        self.board = chess.Board(fen)
        return Response.success(f"Use this FEN success. Current active FEN: [{str(self.board.fen())}]")

    @safe_response
    def move(self, notation):
        assert len(notation) == 4 or len(notation) == 5, f"Move notation must 4 or 5, got {notation}"
        
        if self.board.is_game_over():
            return Response.error("Cannot move because game is over.")

        self.board.push(chess.Move.from_uci(notation))
        return Response.success()

    @safe_response
    def get_best_move(self, thinking_time=0.3):        
        limits = chess.engine.Limit(time=thinking_time)
        return self.on_get_engine_movement(limits)

    @safe_response
    def get_best_move_by_clock(self, white_clock, black_clock, increment=0):
        if increment != 0: 
            raise NotImplementedError
        
        limits = chess.engine.Limit(white_clock=white_clock, black_clock=black_clock)
        return self.on_get_engine_movement(limits)

    @safe_response
    def on_get_engine_movement(self, limits):
        if self.board.is_game_over():
            return Response.error("Cannot get best movement because game is over.")
        
        try:
            engine_result = self.engine_instance.play(self.board, limits, ponder=True, info=chess.engine.INFO_SCORE)
        except Exception as e:
            self.initialize_engine()
            return Response.error(f"On Get Engine Movement: {e}")
        
        return self.on_get_movement_response(engine_result)

    @safe_response
    def on_get_movement_response(self, result):
        message = ""
        
        if result.resigned:
            message = "WARNING - Engine resigned. Trying to reinitialize engine again."
            self.initialize_engine()
        
        return Response.move(
            movement=result.move_uci(),
            score=str(result.info["score"].relative),
            is_resigned=result.resigned,
            is_draw_offered=result.draw_offered,
            message=message
        )

    @safe_response
    def on_finish(self):
        self.engine_instance.close()
        self.engine_instance = None
        return Response.success("Engine on finish success.")
    

class Response:
    
    @staticmethod
    def move(movement: str, score: str, is_resigned: bool, is_draw_offered: bool, message=""):
        return {
            "success": 1,
            "message": message,
            "result": {
                "move": movement,
                "score": score,
                "is_draw_offered": is_draw_offered,
                "is_resigned": is_resigned
            }
        }

    @staticmethod
    def fen(fen: str):
        return {
            "success": 1,
            "fen": fen,
            "message": f"Get current FEN success. FEN: [{fen}]"
        }

    @staticmethod
    def error(reason: str):
        return {
            "success": 0,
            "message": reason
        }
        
    @staticmethod
    def success(message=""):
        return {
            "success": 1,
            "message": message,
        }
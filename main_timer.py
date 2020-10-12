import time
import os
import telegram

IDLE_TIME_UNTIL_SHUTDOWN_SECS = 60 * 60  # ONE HOUR OF INACTIVE


def get_time_since_last_request():
    current_time = int(time.time())
    with open(".time", "r") as time_file:
        last_request = int(time_file.read())
        time_file.flush()
        return current_time - last_request


def send_telegram_message(msg: str):
    try:
        bot = telegram.Bot("1170365304:AAHdMR1ceFZpR98TWtleT-QcWzp1Vns7O4w")
        bot.sendMessage(chat_id="-438498714", text=msg)
    except Exception as e:
        return


def shutdown():
    # Stop VM or via GCP VM Instance
    os.system("sudo shutdown -h now")


def main():
    send_telegram_message("VM just started.")
    while True:
        time.sleep(60)
        elapsed = get_time_since_last_request()
        
        if elapsed > IDLE_TIME_UNTIL_SHUTDOWN_SECS:
            send_telegram_message("No usage detected for the last 60 minutes. Shutting down VM.")
            shutdown()


if __name__ == "__main__":
    main()
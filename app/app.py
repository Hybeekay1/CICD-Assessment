from flask import Flask
import time

app = Flask(__name__)

@app.route('/')
def get_timestamp():
    ts = time.time()
    return {"timestamp": ts}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
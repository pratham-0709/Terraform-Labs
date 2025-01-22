from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, Devadministrator !!"

@app.route("/terraform")
def test():
    return "Hello, Terraform!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
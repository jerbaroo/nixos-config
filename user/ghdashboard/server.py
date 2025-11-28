import flask
import requests
import os

# Data sources ##########################################################################


def github_data(limit, org):
    token = os.getenv("GITHUB_TOKEN")
    if not token:
        raise LookupError("GITHUB_TOKEN not found")
    with open("query.graphql", "r") as f: # TODO: make a global variable
        query = f.read().replace("<<org>>", f"org:{org} " if org else "").replace("<<limit>>", f"last: {limit}" if limit else "last:100")
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.post("https://api.github.com/graphql", json={"query": query}, headers=headers)
    return response.json()


# Flask app #############################################################################

app = flask.Flask(__name__)


@app.route('/data')
def data():
    limit = flask.request.args.get('limit')
    org = flask.request.args.get('org')
    print(f"limit={limit} org={org}")
    try:
        return {"github": github_data(limit=limit, org=org)}
    except Exception as e:
        return {"error": str(e)}, 500


@app.route('/')
def index():
    return flask.send_from_directory('.', 'index.html')


if __name__ == '__main__':
    app.run(debug=True)

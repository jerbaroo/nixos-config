import flask
import requests
import os
import sys
from typing import Optional

# Data sources ##########################################################################


with open("query.graphql", "r") as f:
    query = f.read()


def github_data(limit: Optional[int], order: Optional[str], org: Optional[str]):
    token = os.getenv("GITHUB_TOKEN")
    if not token:
        raise LookupError("GITHUB_TOKEN not found")
    query_ = query.replace(
        "<<limit>>", str(limit) if limit else "100").replace(
        "<<order>>", order if order else "last").replace(
        "<<org>>", f"org:{org} " if org else "")
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.post("https://api.github.com/graphql", json={"query": query_}, headers=headers)
    return response.json()


# Flask app #############################################################################

app = flask.Flask(__name__)


@app.route('/data')
def data():
    limit = flask.request.args.get('limit')
    order = flask.request.args.get('order')
    org = flask.request.args.get('org')
    print(f"limit={limit} org={org}")
    try:
        return {"github": github_data(limit=limit, order=order, org=org)}
    except Exception as e:
        return {"error": str(e)}, 500


@app.route('/')
def index():
    return flask.send_from_directory('.', 'index.html')


if __name__ == '__main__':
    port = sys.argv[1]
    print(f"Port={port}")
    app.run(debug=True, port=port)

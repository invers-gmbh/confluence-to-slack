import requests
import urllib.parse
from slack_webhook import Slack
from tinydb import TinyDB, Query
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--username', '-u', help="username for confluence", required=True, type=str)
parser.add_argument('--password', '-p', help="password for user in confluence", required=True, type=str)
parser.add_argument('--baseurl', '-b', help="base url of your confluence instance", required=True, type=str)
parser.add_argument('--cql', '-c', help="cql to search for confluence pages", required=True, type=str)
parser.add_argument('--slackwebhookurl', '-w', help="url of the slack webhook", required=True, type=str)
parser.add_argument('--message', '-m', help="message to be sent to slack", required=True, type=str)

args = parser.parse_args()
db = TinyDB('/data/db.json')

username = args.username
password = args.password
wikiBaseUrl = args.baseurl
slack_hook_url = args.slackwebhookurl
message = args.message
cql = args.cql

wikiQueryUrl = wikiBaseUrl + '/rest/api/content/search?cql=' + urllib.parse.quote(cql)

response = requests.get(wikiQueryUrl, auth=(username, password))
if response.status_code != 200:
    # This means something went wrong.
    print(f'Error, status code {response.status_code}')
    exit(-1)

json = response.json()
BlogPost = Query()

sentSomething = False

slack = Slack(url=slack_hook_url)
for result in json["results"]:
    result_id = result["id"]
    if len(db.search(BlogPost.id == result_id)) == 0:
        slack.post(
            text=message.replace('{link}', f'<{wikiBaseUrl + result["_links"]["webui"]}|{result["title"]}>')
        )
        db.insert(result)
        sentSomething = True

if not sentSomething:
    print("No news")

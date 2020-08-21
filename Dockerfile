FROM python:3
ADD confluence-to-slack.py /
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

RUN apt-get update && apt-get -y install cron

RUN pip install requests
RUN pip install slack-webhook
RUN pip install tinydb

ENV BASE_URL ""
ENV USERNAME ""
ENV PASSWORD ""
ENV CQL ""
ENV SLACK_WEBHOOK_URL ""
ENV MESSAGE ""
ENV CRON_EXP ""

ENTRYPOINT /entrypoint.sh

#!/bin/bash
: "${USERNAME:?Need to set USERNAME}"
: "${PASSWORD:?Need to set PASSWORD}"
: "${BASE_URL:?Need to set BASE_URL}"
: "${CQL:?Need to set CQL}"
: "${MESSAGE:?Need to set MESSAGE}"
: "${SLACK_WEBHOOK_URL:?Need to set SLACK_WEBHOOK_URL}"
: "${CRON_EXP:?Need to set CRON_EXP}"

echo "Here will be no information shown, please take a look at /var/log/cron.log"

declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

# Setup a cron schedule
echo "SHELL=/bin/bash
BASH_ENV=/container.env
$CRON_EXP echo \"\$(date): \$(python /confluence-to-slack.py -u=\"${USERNAME}\" -p=\"${PASSWORD}\" -b=\"${BASE_URL}\" -c=\"${CQL}\" -m=\"${MESSAGE}\" -w=\"${SLACK_WEBHOOK_URL}\")\" >> /var/log/cron.log 2>&1
# This extra line makes it a valid cron" > scheduler.txt

crontab scheduler.txt

cron -f

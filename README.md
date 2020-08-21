# confluence-to-slack

Simply sent slack messages about new articles and blog posts created in your confluence. Main purpose of this project is, to share blog posts with slack, but via CQL it is possible to share all kinds of articles, comments or other types of content via slack message.

## Usage

You must define some variables, like username, password and baseurl of your confluence instance. Then you must define a [CQL](https://developer.atlassian.com/server/confluence/advanced-searching-using-cql/) that will filter the articles or blog posts that should be sent as slack messages.

Next you must define the [slack webhook url](https://invers.slack.com/apps/A0F7XDUAZ-incoming-webhooks) and the message that should be sent (use `{link}` to get a link with the title as text.

Finally you must define a cron expression when you want to check for new articles (use something like https://crontab.guru/ if you are precarious how to create one.

```shell
docker create volume confluence-to-slack
docker run -v confluence-to-slack:/data \
    -d --name="confluence-to-slack" \
    --env USERNAME=XXX \
    --env PASSWORD=XXX \
    --env BASE_URL=XXX \
    --env CQL="space in (EKB) AND type=blogpost ORDER BY created DESC" \
    --env SLACK_WEBHOOK_URL=https://hooks.slack.com/services/XXXX \
    --env MESSAGE="New blog post: {link}" \
    --env CRON_EXP="* * * * *" \
    inverscom/confluence-to-slack 
```

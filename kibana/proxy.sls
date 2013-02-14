include:
  - nginx

{% from "nginx/init.sls" import proxy %}

{{ proxy(site='kibana', server='127.0.0.1', port='5601', http=False, https=True) }}

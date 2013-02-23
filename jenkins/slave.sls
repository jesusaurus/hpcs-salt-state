include:
  - ssh

{% from "ssh/tunnel.sls" import tunnel %}

{{ tunnel(user='jenkins', jump_host='15.185.231.168', local_port='6379', dest_addr='15.185.231.168', dest_port='6379') }}

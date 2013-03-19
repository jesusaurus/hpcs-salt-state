include:
  - ssh

{% from "ssh/tunnel.sls" import tunnel %}

{{ tunnel(user='jenkins', jump_host=pillar['redis']['server'], local_port=pillar['redis']['port'], dest_addr='127.0.0.1', dest_port=pillar['redis']['port']) }}

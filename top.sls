base:
  '*':
    - fail2ban
  'logstash*':
    - logstash.indexer
    - logstash.web
    - redis
    - elasticsearch

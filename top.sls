base:
  '*':
    - fail2ban
  'roles:logstash-indexer':
    - match: grain
    - logstash.indexer
  'roles:logstash-web':
    - match: grain
    - logstash.web
  'roles:redis':
    - match: grain
    - redis
  'roles:elasticsearch':
    - match: grain
    - elasticsearch
  'roles:rabbitmq':
    - match: grain
    - rabbitmq

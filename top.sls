base:
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

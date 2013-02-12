base:
  'roles:logstash-indexer':
    - match: grain
    - logstash.indexer
  'roles:redis':
    - match: grain
    - redis
  'roles:elasticsearch':
    - match: grain
    - elasticsearch

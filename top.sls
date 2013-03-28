base:
  '*':
    - fail2ban
  'logstash*':
    - logstash.indexer
    - logstash.web
    - redis
    - redis.jenkins
    - elasticsearch
  'jenkins.*':
    - jenkins.master
  'msgaas*.jenkins*':
    - jenkins.msgaas
  'dbaas*.jenkins*':
    - jenkins.dbaas
  'pypi*':
    - pypi
  'apt*':
    - apt.server

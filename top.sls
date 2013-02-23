base:
  '*':
    - fail2ban
  'logstash*':
    - logstash.indexer
    - logstash.web
    - redis
    - redis.jenkins
    - elasticsearch
  '*jenkins-slave':
    - jenkins.slave

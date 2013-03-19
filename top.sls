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
  '*jenkins-slave':
    - match: pcre
    - jenkins.slave

#set up a jenkins user for the sole purpose of allowing ssh for an ssh-tunnel to redis from jenkins slaves
redis_jenkins:
  user.present:
    - name: jenkins

{{ pillar['pubkeys']['jenkins_slave_root']['key'] }}:
  ssh_auth:
    - present
    - user: jenkins
    - enc: {{ pillar['pubkeys']['jenkins_slave_root']['enc'] }}
    - comment: {{ pillar['pubkeys']['jenkins_slave_root']['comment'] }}
    - require:
      - user: jenkins

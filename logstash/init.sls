include:
  - java

logstash:
  user.present:
    - home: /mnt/logstash
    - shell: /bin/nologin
    - system: True
    - gid_from_name: True
    - require:
      - group: logstash
  group.present:
    - system: True

/mnt/logstash/logstash.jar:
  file.managed:
    - source: salt://logstash/logstash-1.1.9-monolithic.jar 
    - user: logstash
    - group: logstash
    - require:
      - user: logstash
      - group: logstash
      - pkg: java

/var/log/logstash:
  file.directory:
    - user: logstash
    - group: logstash
    - require:
      - user: logstash
      - group: logstash

/etc/logstash:
  file.directory:
    - user: logstash
    - group: logstash
    - require:
      - user: logstash
      - group: logstash

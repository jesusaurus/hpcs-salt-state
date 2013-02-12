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
    - source: https://logstash.objects.dreamhost.com/release/logstash-1.1.9-monolithic.jar 
    - source_hash: md5=70addd3ccd37e796f473fe5647c31126
    - user: logstash
    - group: logstash
    - require:
      - user: logstash
      - group: logstash

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

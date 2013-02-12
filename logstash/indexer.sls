include:
  - logstash

file.managed:
  - name: /etc/init/logstash-indexer.conf
  - source: salt://logstash/indexer.init
  - user: root
  - group: root

file.managed:
  - name: /etc/logstash/indexer.conf
  - source: salt://logstash/indexer.init
  - user: logstash
  - group: logstash
  - require:
    - file: /etc/logstash

service.running:
  - name: logstash-indexer
  - require:
    - file: /etc/init/logstash-indexer.conf
    - file: /etc/logstash/indexer.conf
    - file: /var/log/logstash
  - watch:
    - file: /etc/logstash/indexer.conf


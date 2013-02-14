include:
  - logstash

/etc/init/logstash-indexer.conf:
  file.managed:
    - source: salt://logstash/indexer.init
    - user: root
    - group: root

/etc/logstash/indexer.conf:
  file.managed:
    - source: salt://logstash/indexer.conf
    - template: jinja
    - user: logstash
    - group: logstash
    - require:
      - file: /etc/logstash

logstash-indexer:
  service.running:
    - require:
      - file: /etc/init/logstash-indexer.conf
      - file: /etc/logstash/indexer.conf
      - file: /var/log/logstash
    - watch:
      - file: /etc/logstash/indexer.conf
  

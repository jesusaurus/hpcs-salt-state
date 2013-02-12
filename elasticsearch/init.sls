include:
  - java

elasticsearch:
  pkg:
    - installed
    - sources: 
      - elasticsearch: http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.2.deb
  service.running:
    - require:
      - pkg: elasticsearch
      - file: /mnt/elasticsearch
      - file: /var/log/elasticsearch
    - watch:
      - file: /etc/elasticsearch/elasticsearch.yml
      - file: /etc/elasticsearch/default_mapping.json

/mnt/elasticsearch:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - require:
      - pkg: elasticsearch

/var/log/elasticsearch:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - require:
      - pkg: elasticsearch

/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: salt://elasticsearch/elasticsearch.yml
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: elasticsearch

/etc/elasticsearch/default_mapping.json:
  file.managed:
    - source: salt://elasticsearch/default_mapping.json
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: elasticsearch

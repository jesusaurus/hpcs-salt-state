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

/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: salt://elasticsearch/elasticsearch.yml
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: elasticsearch

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

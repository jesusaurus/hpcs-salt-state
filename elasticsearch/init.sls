# Copyright 2012-2013 Hewlett-Packard Development Company, L.P.
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#
include:
  - java

elasticsearch:
  pkg:
    - installed
    - sources:
      - elasticsearch: http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.0.deb
    - require:
      - pkg: java
  service.running:
    - require:
      - pkg: elasticsearch
      - file: /mnt/elasticsearch
      - file: /var/log/elasticsearch
      - file: /etc/init.d/elasticsearch
      - file: /etc/security/limits.d/elasticsearch.conf

/etc/init.d/elasticsearch:
  file.managed:
    - source: salt://elasticsearch/elasticsearch.initd
    - require:
      - pkg: elasticsearch

/etc/security/limits.d/elasticsearch.conf:
  file.managed:
    - contents: "elasticsearch - nofile 2097152"

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

/etc/elasticsearch/default-mapping.json:
  file.managed:
    - source: salt://elasticsearch/default-mapping.json
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: elasticsearch

/etc/elasticsearch/templates/logstash.json:
  file.managed:
    - makedirs: true
    - source: salt://elasticsearch/logstash-template.json

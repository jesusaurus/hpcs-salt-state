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
  service.running:
    - require:
      - pkg: java
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

/etc/elasticsearch/default_mapping.json:
  file.managed:
    - source: salt://elasticsearch/default_mapping.json
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: elasticsearch

/etc/default/elasticsearch:
  file.managed:
    - source: salt://elasticsearch/elasticsearch.default
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: elasticsearch

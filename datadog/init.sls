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

datadog:
{% if grains['os_family'] == 'Debian' %}
  pkgrepo.managed:
    - name: deb http://apt.datadoghq.com/ unstable main
    - file: /etc/apt/sources.list.d/datadog.list
    - keyserver: keyserver.ubuntu.com
    - keyid: C7A7DA52
{% endif %}
  pkg.latest:
    - name: datadog-agent
    - require:
      - pkgrepo: datadog
  service.running:
    - enabled: True
    - name: datadog-agent
    - require:
      - pkg: datadog
    - watch:
      - file: /etc/dd-agent/datadog.conf

{% if pillar.get('redis', false) %}
python-redis:
  pkg.latest:
    - require-in:
      - service: datadog

/etc/dd/agent/conf.d/redisdb.yaml:
  file.managed:
    - source: salt://datadog/redisdb.yaml
    - template: jinja
    - require_in:
      - service: datadog
{% endif %}

{% if pillar.get('elasticsearch', false) %}
/etc/dd/agent/conf.d/elastic.yaml:
  file.managed:
    - source: salt://datadog/elastic.yaml
    - template: jinja
    - require_in:
      - service: datadog
{% endif %}

/etc/dd-agent/datadog.conf.example:
  file.managed:
    - source: salt://datadog/datadog.conf.example

/etc/dd-agent/datadog.conf:
  file.managed:
    - template: jinja
    - source: salt://datadog/datadog.conf

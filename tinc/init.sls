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

tinc:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: tinc

{% for network in pillar['tinc'].keys() %}

/etc/tinc/{{ network }}:
  file.directory:
    - require:
      - pkg: tinc

/etc/tinc/{{ network }}/hosts:
  file.directory:
    - require:
      - file: /etc/tinc/{{ network }}

{% if pillar['tinc'][network].get('autostart', False) %}
/etc/tinc/nets.boot:
  file.append:
    - text: {{ network }}
    - require:
      - file: /etc/tinc/{{ network }}
{% endif %}

/etc/tinc/{{ network }}/rsa_key.priv:
  file.managed:
    - source: salt://tinc/key
    - mode: 600
    - template: jinja
    - context: { network: {{ network }} }
    - require:
      - file: /etc/tinc/{{ network }}

/etc/tinc/{{ network }}/tinc.conf:
  file.managed:
    - source: salt://tinc/tinc.conf
    - template: jinja
    - context: { network: {{ network }} }
    - require:
      - file: /etc/tinc/{{ network }}

/etc/tinc/{{ network }}/tinc-up:
  file.managed:
    - source: salt://tinc/tinc-up
    - mode: 750
    - template: jinja
    - context: { network: {{ network }} }
    - require:
      - file: /etc/tinc/{{ network }}

/etc/tinc/{{ network }}/tinc-down:
  file.managed:
    - source: salt://tinc/tinc-down
    - mode: 750
    - template: jinja
    - context: { network: {{ network }} }
    - require:
      - file: /etc/tinc/{{ network }}

{% for host in pillar['tinc'][network]['hosts'].keys() %}
/etc/tinc/{{ network }}/hosts/{{ host }}:
  file.managed:
    - source: salt://tinc/host
    - template: jinja
    - context: { network: {{ network }}, host: {{ host }} }
    - require:
      - file: /etc/tinc/{{ network }}
{% endfor %}

{% endfor %}

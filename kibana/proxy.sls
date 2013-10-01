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
  - apache
  - apache.mod.authopenid
  - apache.mod.proxy
  - apache.mod.proxy_http
  - apache.mod.rewrite
  - apache.mod.ssl

/etc/apache2/sites-enabled/000-default:
  file:
    - absent

/etc/apache2/sites-enabled/default:
  file.managed:
    - source: salt://kibana/apache.conf
    - template: jinja
    - require:
      - file: {{ salt['pillar.get']('kibana:htpasswd:path') }}
      - file: {{ salt['pillar.get']('kibana:cert:path') }}
      - file: {{ salt['pillar.get']('kibana:key:path') }}
{% if salt['pillar.get']('kibana:chain', False) %}
      - file: {{ salt['pillar.get']('kibana:chain:path') }}
{% endif %}
    - watch_in:
      - service: {{ pillar['package']['apache'] }}

/var/www/kibana.htpasswd:
  file.managed:
    - contents: |
        {{ salt['pillar.get']('kibana:htpasswd:contents') | indent(8) }}

/etc/ssl/certs/kibana.proxy.crt:
  file.managed:
    - contents: |
        {{ salt['pillar.get']('kibana:cert:contents') | indent(8) }}

/etc/ssl/private/kibana.proxy.key:
  file.managed:
    - contents: |
        {{ salt['pillar.get']('kibana:key:contents') | indent(8) }}

{% if salt['pillar.get']('kibana:chain', False) %}
{{ salt['pillar.get']('kibana:chain:path') }}:
  file.managed:
    - contents: |
        {{ salt['pillar.get']('kibana:chain:contents') | indent(8) }}
{% endif %}

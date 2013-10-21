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

{% for key in salt['pillar.get']('redis:tunnel:pubkeys', []) %}
{{ key['key'] }}:
  ssh_auth.present:
    - user: logstash
    - enc: {{ key['type'] }}
    - comment: {{ key['comment'] }}
    - options:
      - no-pty
      - no-X11-forwarding
      - permitopen="localhost:6379"
      - command="/bin/echo Please only use this connection to establish an ssh tunnel to redis."
{% endfor %}

{% for type in ['rsa', 'dsa', 'ecdsa'] %}
/etc/ssh/ssh_host_{{type}}_key:
  file.managed:
    - mode: 600
    - contents: |
{{ salt['pillar.get']('redis:tunnel:hostkeys:' + type + ':private') | indent(8, true) }}

/etc/ssh/ssh_host_{{type}}_key.pub:
  file.managed:
    - mode: 644
    - contents: |
{{ salt['pillar.get']('redis:tunnel:hostkeys:' + type + ':public') | indent(8, true) }}
{% endfor %}

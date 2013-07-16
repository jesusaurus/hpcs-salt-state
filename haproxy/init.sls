# Copyright 2013 Hewlett-Packard Development Company, L.P.
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

haproxy:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: haproxy
    - watch:
      - file: /etc/haproxy/haproxy.cfg
      - file: /etc/default/haproxy

/etc/rsyslog.d/10-haproxy.conf:
  file.managed:
    - source: salt://haproxy/rsyslog.d.conf
    - require:
      - pkg: haproxy

/etc/logrotate.d/haproxy:
  file.managed:
    - source: salt://haproxy/logrotate.conf
    - require:
      - pkg: haproxy

/etc/default/haproxy:
  file.managed:
    - source: salt://haproxy/haproxy.default
    - require:
      - pkg: haproxy

/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: salt://haproxy/haproxy.cfg
    - template: jinja
    - require:
      - pkg: haproxy


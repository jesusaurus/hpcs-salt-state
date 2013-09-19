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
fail2ban:
  pkg:
    - latest
  service.running:
    - require:
      - pkg: fail2ban
    - watch:
      - file: fail2ban.conf
      - file: fail2ban.jail.conf
      - file: fail2ban.jail.local

fail2ban.conf:
  file.managed:
    - name: /etc/fail2ban/fail2ban.conf
    - user: root
    - group: root
    - mode: 0644
    - source: salt://fail2ban/fail2ban.conf
    - require:
      - pkg: fail2ban

fail2ban.jail.conf:
  file.managed:
    - name: /etc/fail2ban/jail.conf
    - user: root
    - group: root
    - mode: 0644
    - source: salt://fail2ban/jail.conf
    - require:
      - pkg: fail2ban

fail2ban.jail.local:
  file.managed:
    - name: /etc/fail2ban/jail.local
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: fail2ban


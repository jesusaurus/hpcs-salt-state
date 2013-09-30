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

# make hpcloud instances aware of their public ips
{% if pillar['network']['addr'].get(grains['host'], false) %}
{% for ip in pillar['network']['addr'][grains['host']] %}
public_ip_{{ip}}:
  cmd.run:
    - name: ip addr add {{ ip }}/32 dev lo
    - unless: ip addr show | grep {{ ip }}
{% endfor %}
{% endif %}

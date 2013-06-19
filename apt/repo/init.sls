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
  - apt

{% set path = pillar['apt']['repo']['path'] %}

{% for dir in [ 'conf', 'dists', 'pool' ] %}
{{ path }}/{{ dir }}:
  file.directory:
    - makedirs: True
{% endfor %}

{% if pillar['apt']['repo'].get('distros', false) %}
{{ path }}/conf/distributions:
  file.managed:
    - source: salt://apt/repo/distro
    - template: jinja
    - require:
      - file: {{ path }}/conf
{% endif %}

{{ path }}/conf/options:
  file.managed:
    - source: salt://apt/repo/options
    - template: jinja
    - require:
      - file: {{ path }}/conf

{% if pillar['apt']['repo'].get('pulls', false) %}
{{ path }}/conf/pulls:
  file.managed:
    - source: salt://apt/repo/pulls
    - template: jinja
    - require:
      - file: {{ path }}/conf
{% endif %}

{% if pillar['apt']['repo'].get('updates', false) %}
{{ path }}/conf/updates:
  file.managed:
    - source: salt://apt/repo/updates
    - template: jinja
    - require:
      - file: {{ path }}/conf
{% endif %}

'reprepro --silent --basedir {{ path }} update ; reprepro --silent --basedir {{ path }} pull ; reprepro --silent --basedir {{ path }} export':
  cron.present:
    - minute: 0
    - hour: 0

{% if pillar['apt']['repo'].get('filter', false) %}
{{ path }}/conf/filter.list:
  file.managed:
    - source: salt://apt/repo/filter.list
    - template: jinja
{% endif %}


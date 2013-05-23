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
{% macro repo(label, desc, releases, arch, component, path) %}

{% for name in [ 'dists', 'indices', 'pool', 'project' ] %}

{{ path }}/{{ name }}:
  file.directory:
    - makedirs: True

{% endfor %}

{{ path }}/conf:
  file.directory:
    - makedirs: True
    - mode: 750

{{ path }}/conf/distributions:
  file.managed:
    - source: salt://apt/repo/distro
    - template: jinja
    - context: {
      label: {{ label }},
      desc: {{ desc }},
      arch: {{ arch }},
      component: {{ component }},
      releases: {{ releases }} }
    - require:
      - file: {{ path }}/conf

{{ path }}/conf/updates:
  file.managed:
    - source: salt://apt/repo/updates
    - template: jinja
    - context: {
      arch: {{ arch }},
      component: {{ component }} }
    - require:
      - file: {{ path }}/conf

{{ path }}/conf/options:
  file.managed:
    - source: salt://apt/repo/options
    - require:
      - file: {{ path }}/conf

'reprepro --silent --basedir {{ path }} update':
  cron.present:
    - minute: 0
    - hour: 0

{% endmacro %}

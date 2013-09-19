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
  - pypi.cache
  - nginx

{% from "nginx/proxy.sls" import proxy %}

{{ proxy(site='default', server='127.0.0.1', port=salt['pillar.get']('pypi:port', '8080'), http=True, https=False) }}

{{ salt['pillar.get']('pypi:user', 'pypi') }}:
  group:
    - present
  user.present:
    - home: {{ salt['pillar.get']('pypi:home', '/home/pypi') }}
    - shell: /bin/bash
    - gid_from_name: True
    - require:
      - group: {{ salt['pillar.get']('pypi:user', 'pypi') }}


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
  - pip
  - pypi.proxy

{{ pillar['pypi']['user'] }}:
  group:
    - present
  user.present:
    - home: {{ pillar['pypi']['home'] }}
    - shell: /bin/bash
    - gid_from_name: True
    - require:
      - group: {{ pillar['pypi']['user'] }}

passlib:
  pip.installed:
    - require:
      - pkg: pip

pypiserver:
  pip.installed:
    - require:
      - pkg: pip
      - user: {{ pillar['pypi']['user'] }}
  service.running:
    - enabled: True
    - require:
      - file: {{ pillar['pypi']['path'] }}
      - file: /etc/init.d/pypiserver
      - file: /etc/default/pypiserver

{{ pillar['pypi']['path'] }}:
  file.directory:
    - makedirs: True
    - user: {{ pillar['pypi']['user'] }}
    - group: {{ pillar['pypi']['user'] }}
    - recurse:
      - user
      - group
    - require:
      - user: {{ pillar['pypi']['user'] }}

/etc/init.d/pypiserver:
  file.managed:
    - source: salt://pypi/pypiserver.init
    - mode: 755

/etc/default/pypiserver:
  file.managed:
    - source: salt://pypi/pypiserver.conf
    - template: jinja

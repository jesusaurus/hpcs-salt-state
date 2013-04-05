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
  - git
  - java

jenkins:
  user.present:
    - home: /home/jenkins
    - shell: /bin/sh
    - gid_from_name: True
    - require:
      - group: jenkins
  group:
    - present

{{ pillar['pubkeys']['jenkins_master']['key'] }}:
  ssh_auth:
    - present
    - user: jenkins
    - enc: {{ pillar['pubkeys']['jenkins_master']['enc'] }}
    - comment: {{ pillar['pubkeys']['jenkins_master']['comment'] }}
    - require:
      - user: jenkins

java_sdk:
  pkg.installed:
    - name: {{ pillar['package']['java_sdk'] }}
maven:
  pkg:
    - installed
python-virtualenv:
  pkg:
    - installed
{% if grains['os_family'] == 'Debian' %}
build-essential:
  pkg:
    - installed
python-dev:
  pkg:
    - installed
{% elif grains['os_family'] == 'RedHat' %}
python-devel:
  pkg:
    - installed
gcc:
  pkg:
    - installed
gcc-c++:
  pkg:
    - installed
make:
  pkg:
    - installed
autoconf:
  pkg:
    - installed
pkgconfig:
  pkg:
    - installed
libtool:
  pkg:
    - installed
{% endif %}

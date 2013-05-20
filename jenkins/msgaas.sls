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
  - jenkins.slave

java_sdk:
  pkg.installed:
    - name: {{ pillar['package']['java_sdk'] }}

/home/jenkins/.m2:
  file.directory:
    - user: jenkins
    - group: jenkins
    - mode: 750
    - require:
      - user: jenkins

/home/jenkins/.m2/settings.xml:
  file.managed:
    - user: jenkins
    - group: jenkins
    - mode: 640
    - template: jinja
    - source: salt://jenkins/m2-settings.xml
    - require:
      - user: jenkins
      - file: /home/jenkins/.m2

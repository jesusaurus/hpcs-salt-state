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
  - jenkins.slave
  - pip

extra_build:
  pkg.installed:
    - name: bc
  pkg.installed:
    - name: debhelper
  pkg.installed:
    - name: libmysqlclient-dev
  pkg.installed:
    - name: libxslt1-dev
  pkg.installed:
    - name: python-pexpect
  pkg.installed:
    - name: python-pycurl
  pkg.installed:
    - name: reprepro
  pip.installed:
    - name: tox
    - require:
      - pkg: pip

/home/jenkins/.pypirc:
  file.managed:
    - user: jenkins
    - mode: 600
    - source: salt://jenkins/dbaas-pypirc
    - template: jinja

/var/lib/jenkins/dbaas-dev-az2.pem:
  file:
    - exists

/var/lib/jenkins/dbaas-instance.pem:
  file:
    - exists

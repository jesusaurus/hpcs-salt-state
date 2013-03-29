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
  - gems
  - git

bundler:
  gem:
    - installed
    - require:
      - pkg: rubygems

kibana:
  user:
    - present
    - home: /mnt/kibana
    - system: True
    - gid_from_name: True
    - require:
      - group: kibana
  group:
    - present
    - system: True
  git.latest:
    - name: https://github.com/rashidkpc/Kibana.git
    - rev: v0.2.0
    - target: /mnt/kibana
    - runas: kibana
    - require:
      - pkg: git
      - file: /mnt/kibana
  cmd.wait:
    - name: bundle install
    - cwd: /mnt/kibana
    - require:
      - gem: bundler
      - file: /mnt/kibana/KibanaConfig.rb
    - watch:
      - git: kibana
      - file: /mnt/kibana/KibanaConfig.rb
  service.running:
    - require:
      - file: /etc/init/kibana.conf
      - cmd: kibana
    - watch:
      - file: /etc/init/kibana.conf
      - file: /mnt/kibana/KibanaConfig.rb

/mnt/kibana:
  file.directory:
    - user: kibana
    - group: kibana

/mnt/kibana/KibanaConfig.rb:
  file.managed:
    - source: salt://kibana/config.rb
    - user: kibana
    - group: kibana
    - require:
      - user: kibana
      - group: kibana
      - git: kibana

/etc/init/kibana.conf:
  file.managed:
    - source: salt://kibana/kibana.init
    - user: root
    - group: root
    - mode: 0644

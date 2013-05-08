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

redis:
  user.present:
    - home: /mnt/redis
    - gid_from_name: True
    - require:
      - group: redis
  group:
    - present

/mnt/redis:
  file.directory:
    - user: redis
    - group: redis
    - require:
      - user: redis
      - group: redis

/var/lib/redis:
  file.directory:
    - user: redis
    - group: redis
    - require:
      - user: redis
      - group: redis

https://github.com/antirez/redis.git:
  git.latest:
    - rev: 2.6.13
    - force: True
    - target: /mnt/redis/src
    - require:
      - pkg: git
      - file: /mnt/redis

redis-install:
  cmd.wait:
    - name: 'make && make PREFIX=/usr install' 
    - cwd: /mnt/redis/src
    - watch:
      - git: https://github.com/antirez/redis.git

redis-server:
  service:
    - running
    - require:
      - file: /etc/init.d/redis-server
    - watch:
      - cmd: redis-install
      - file: /etc/redis/redis.conf

/etc/init.d/redis-server:
  file.managed:
    - source: salt://redis/redis.init

/etc/redis/redis.conf:
  file.managed:
    - source: salt://redis/redis.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

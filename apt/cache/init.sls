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

apt-cacher-ng:
  pkg:
    - installed
  user:
    - present
    - require:
      - pkg: apt-cacher-ng
  group:
    - present
    - require:
      - pkg: apt-cacher-ng
  service.running:
    - require:
      - pkg: apt-cacher-ng
    - watch:
      - file: /etc/apt-cacher-ng/acng.conf

/etc/apt-cacher-ng/acng.conf:
  file.managed:
    - source: salt://apt/cache/acng.conf
    - template: jinja

/etc/apt-cacher-ng/merge_urls:
  file.managed:
    - source: salt://apt/cache/merge_urls
    - template: jinja

/etc/apt-cacher-ng/target_urls:
  file.managed:
    - source: salt://apt/cache/target_urls
    - template: jinja

{{ pillar['apt']['cache']['path'] }}:
  file.directory:
    - makedirs: True
    - user: apt-cacher-ng
    - require:
      - user: apt-cacher-ng

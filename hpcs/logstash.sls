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
  - tinc
  - redis
  - redis.tunnel
  - redis.jenkins
  - haproxy
  - logstash.web
  - logstash.queue

{% from "logstash/indexer.sls" import indexer %}

{% for x in [ '1', '2', '3' ] %}
{{ indexer(i=x,
           rpass=salt['pillar.get']('redis:password'),
           ehost=salt['pillar.get']('elasticsearch:publish:esmaster' + x, '127.0.0.1'),
           eflush=500) }}
{% endfor %}

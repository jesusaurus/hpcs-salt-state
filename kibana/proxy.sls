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
  - apache
  - apache.mod.authopenid
  - apache.mod.proxy
  - apache.mod.proxy_http
  - apache.mod.rewrite
  - apache.mod.ssl

/etc/apache2/sites-enabled/000-default:
  file:
    - absent

/etc/apache2/sites-enabled/default:
  file.managed:
    - source: salt://kibana/apache.conf
    - template: jinja
    - require:
      - file: /etc/ssl/certs/kibana.proxy.crt
      - file: /etc/ssl/private/kibana.proxy.key
      - file: /var/www/kibana.htpasswd
    - watch_in:
      - service: {{ pillar['package']['apache'] }}

/var/www/kibana.htpasswd:
  file:
    - exists

/etc/ssl/certs/kibana.proxy.crt:
  file:
    - exists

/etc/ssl/private/kibana.proxy.key:
  file:
    - exists

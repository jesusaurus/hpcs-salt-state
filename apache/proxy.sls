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

{% for mod in [ 'proxy', 'proxy_http', 'ssl' ] %}
a2enmod {{ mod }}:
  cmd.run:
    - require:
      - pkg: apache2
{% endfor %}

{% macro proxy(site, server, port, http=True, https=False) -%}
/etc/apache2/sites-enabled/{{ site }}:
  file.managed:
    - source: salt://apache/proxy.conf
    - template: jinja
    - context: {
      site: {{ site }},
      server: {{ server }},
      port: {{ port }},
      http: {{ http }},
      https: {{ https }} }
    {% if https -%}
    - require:
      - file: /etc/ssl/certs/{{ site }}.proxy.crt
      - file: /etc/ssl/private/{{ site }}.proxy.key
    {%- endif %}
    - watch_in:
      - service: apache2

{% if https -%}
/etc/ssl/certs/{{ site }}.proxy.crt:
  file:
    - exists

/etc/ssl/private/{{ site }}.proxy.key:
  file:
    - exists
{%- endif %}

{%- endmacro %}

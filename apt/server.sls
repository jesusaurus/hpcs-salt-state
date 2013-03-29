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
  - apt.repo
  - nginx

{% from "apt/repo.sls" import repo %}
{% from "nginx/server.sls" import server %}

{{ repo(label=pillar['repo']['label'], desc=pillar['repo']['desc'], release=pillar['repo']['release'], arch=pillar['repo']['arch'], path=pillar['apt']['path']) }}

{{ server(site='apt', port='80', path=pillar['apt']['path']) }}

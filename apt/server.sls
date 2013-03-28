include:
  - apt.repo
  - nginx

{% from "apt/repo.sls" import repo %}
{% from "nginx/server.sls" import server %}

{{ repo(label='HPCS', desc='HPCS Private Repo', release='precise', arch='i386 amd64 source', path=pillar['apt']['path']) }}

{{ server(site='apt', port='80', path=pillar['apt']['path']) }}

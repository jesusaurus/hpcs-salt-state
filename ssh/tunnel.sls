{% from "upstart/job.sls" import job %}

{% macro tunnel(user, jump_host, local_port, dest_addr, dest_port, bind_addr='localhost', ssh_key=None) -%}

{% if ssh_key -%}
{{ ssh_key }}:
  file.exists:
    - name: {{ ssh_key }}
    - require_in:
      - service: {{ 'sshtunnel_' + local_port }}
{% set cmd = 'ssh -N -L ' + bind_addr + ':' + local_port + ':' + dest_addr + ':' + dest_port + ' -i ' + ssh_key + ' ' + user + '@' + jump_host %}
{% else %}
{% set cmd = 'ssh -N -L ' + bind_addr + ':' + local_port + ':' + dest_addr + ':' + dest_port + ' ' + user + '@' + jump_host %}
{%- endif %}

{{ job(service="sshtunnel_" + local_port, description="sshtunnel_" + local_port, command=cmd) }}

{%- endmacro %}

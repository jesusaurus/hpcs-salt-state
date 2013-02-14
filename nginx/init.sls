nginx:
  pkg:
    - installed
  service:
    - running

{% macro proxy(site, server, port, http=True, https=False) -%}

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/sites-enabled/{{ site }}

/etc/nginx/sites-enabled/{{ site }}:
  file.managed:
    - source: salt://kibana/proxy.conf
    - template: jinja
    - context: {
      site: {{ site }},
      server: {{ server }},
      port: {{ port }},
      http: {{ http }},
      https: {{ https }} }
    {% if https -%}
    - require:
      - file: /var/lib/nginx/ssl/{{ site }}.proxy.crt
      - file: /var/lib/nginx/ssl/{{ site }}.proxy.key
    {%- endif %}

{% if https -%}
/var/lib/nginx/ssl/{{ site }}.proxy.crt:
  file:
    - exists

/var/lib/nginx/ssl/{{ site }}.proxy.key:
  file:
    - exists
{%- endif %}

{%- endmacro %}


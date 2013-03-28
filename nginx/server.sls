{% macro server(site, port, path) %}

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/sites-enabled/{{ site }}

/etc/nginx/sites-enabled/{{ site }}:
  file.managed:
    - source: salt://nginx/server.conf
    - template: jinja
    - context: {
      site: {{ site }}
      port: {{ port }}
      path: {{ path }} }

{% endmacro %}

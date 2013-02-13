include:
  - nginx

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/sites-enabled/default

/etc/nginx/sites-enabled/default:
  file.managed:
    - source: salt://kibana/proxy.conf


nginx:
  pkg:
    - installed
  service:
    - running

/var/lib/nginx/ssl/kibana.proxy.crt:
  file:
    - exists

/var/lib/nginx/ssl/kibana.proxy.key:
  file:
    - exists

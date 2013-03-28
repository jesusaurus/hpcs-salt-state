include:
  - fail2ban.nginx

nginx:
  pkg:
    - installed
  service:
    - running

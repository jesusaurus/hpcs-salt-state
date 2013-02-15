include:
  - fail2ban

fail2ban.jail.nginx:
  file.append:
    - name: /etc/fail2ban/jail.local
    - source: salt://fail2ban/jail.nginx
    - require:
      - file: fail2ban.jail.local

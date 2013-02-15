fail2ban:
  pkg:
    - installed
  service.running:
    - watch:
      - file: fail2ban.conf
      - file: fail2ban.jail.conf
      - file: fail2ban.jail.local

fail2ban.conf:
  file.managed:
    - name: /etc/fail2ban/fail2ban.conf
    - user: root
    - group: root
    - mode: 0644
    - source: salt://fail2ban/fail2ban.conf
    - require:
      - pkg: fail2ban

fail2ban.jail.conf:
  file.managed:
    - name: /etc/fail2ban/jail.conf
    - user: root
    - group: root
    - mode: 0644
    - source: salt://fail2ban/jail.conf
    - require:
      - pkg: fail2ban

fail2ban.jail.local:
  file.managed:
    - name: /etc/fail2ban/jail.local
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: fail2ban


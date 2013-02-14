redis-server:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: redis-server
    - watch:
      - file: /etc/redis/redis.conf

/etc/redis/redis.conf:
  file.managed:
    - source: salt://redis/redis.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: redis-server

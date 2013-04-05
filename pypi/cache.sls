include:
  - pip
  - git

pypicache_install:
  git.latest:
    - name: https://github.com/micktwomey/pypicache.git
    - target: /usr/local/src/pypicache
    - require:
      - pkg: git
  cmd.wait:
    - name: python setup.py install
    - cwd: /usr/local/src/pypicache
    - require:
      - cmd: pypicache_deps
    - watch:
      - git: pypicache_install

pypicache_deps:
  cmd.wait:
    - name: 'pip install -r requirements.txt'
    - cwd: /usr/local/src/pypicache
    - require:
      - pkg: pip
    - watch:
      - git: pypicache_install

pypicache:
  cmd.run:
    - name: 'python -m pypicache.main --port {{ pillar['pypi']['port'] }} {{ pillar['pypi']['path'] }} > /var/log/pypicache.log 2> /var/log/pypicache.err &'
    - user: {{ pillar['pypi']['user'] }}
    - unless: 'lsof -i :{{ pillar['pypi']['port'] }}'
    - require:
      - user: {{ pillar['pypi']['user'] }}
      - file: {{ pillar['pypi']['path'] }}
      - file: /var/log/pypicache.log
      - file: /var/log/pypicache.err
    - watch:
      - cmd: pypicache_install

/var/log/pypicache.log:
  file.managed:
    - user: {{ pillar['pypi']['user'] }}

/var/log/pypicache.err:
  file.managed:
    - user: {{ pillar['pypi']['user'] }}

{{ pillar['pypi']['path'] }}:
  file.directory:
    - user: {{ pillar['pypi']['user'] }}

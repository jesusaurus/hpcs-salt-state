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
    - name: 'python -m pypicache.main --port {{ salt['pillar.get']('pypi:port', '8080') }} {{ salt['pillar.get']('pypi:path', '/var/cache/pypi') }} > /var/log/pypicache.log 2> /var/log/pypicache.err &'
    - user: {{ salt['pillar.get']('pypi:user', 'pypi') }}
    - unless: 'lsof -i :{{ salt['pillar.get']('pypi:port', '8080') }}'
    - require:
      - user: {{ salt['pillar.get']('pypi:user', 'pypi') }}
      - file: {{ salt['pillar.get']('pypi:path', '/var/cache/pypi') }}
      - file: /var/log/pypicache.log
      - file: /var/log/pypicache.err
    - watch:
      - cmd: pypicache_install

/var/log/pypicache.log:
  file.managed:
    - user: {{ salt['pillar.get']('pypi:user', 'pypi') }}

/var/log/pypicache.err:
  file.managed:
    - user: {{ salt['pillar.get']('pypi:user', 'pypi') }}

{{ salt['pillar.get']('pypi:path', '/var/cache/pypi') }}:
  file.directory:
    - user: {{ salt['pillar.get']('pypi:user', 'pypi') }}

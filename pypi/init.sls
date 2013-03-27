include:
  - pip
  - pypi.proxy

{{ pillar['pypi']['user'] }}:
  group:
    - present
  user.present:
    - home: {{ pillar['pypi']['home'] }}
    - shell: /bin/bash
    - gid_from_name: True
    - require:
      - group: {{ pillar['pypi']['user'] }}

passlib:
  pip.installed:
    - require:
      - pkg: pip

pypiserver:
  pip.installed:
    - require:
      - pkg: pip
      - user: {{ pillar['pypi']['user'] }}
  service.running:
    - enabled: True
    - require:
      - file: {{ pillar['pypi']['path'] }}
      - file: /etc/init.d/pypiserver
      - file: /etc/default/pypiserver

{{ pillar['pypi']['path'] }}:
  file.directory:
    - makedirs: True
    - user: {{ pillar['pypi']['user'] }}
    - group: {{ pillar['pypi']['user'] }}
    - recurse:
      - user
      - group
    - require:
      - user: {{ pillar['pypi']['user'] }}

/etc/init.d/pypiserver:
  file.managed:
    - source: salt://pypi/pypiserver.init
    - mode: 755

/etc/default/pypiserver:
  file.managed:
    - source: salt://pypi/pypiserver.conf
    - template: jinja

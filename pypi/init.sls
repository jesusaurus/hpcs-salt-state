include:
  - pip

pypi:
  group:
    - present
  user.present:
    - home: {{ pillar['pypi']['home'] }}
    - shell: /bin/bash
    - gid_from_name: True
    - require:
      - group: pypi

pypiserver:
  pip.installed:
    - require:
      - pkg: pip
      - user: pypi
  service.running:
    - enabled: True
    - require:
      - file: {{ pillar['pypi']['path'] }}
      - file: /etc/init.d/pypiserver
      - file: /etc/default/pypiserver

{{ pillar['pypi']['path'] }}:
  file.directory:
    - makedirs: True
    - user: pypi
    - group: pypi
    - recurse:
      - user
      - group
    - require:
      - user: pypi

/etc/init.d/pypiserver:
  file.managed:
    - source: salt://pypi/pypiserver.init
    - mode: 755

/etc/default/pypiserver:
  file.managed:
    - source: salt://pypi/pypiserver.conf

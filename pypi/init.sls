pypi:
  group:
    - present
  user.present:
    - home: /var/local/pypi
    - shell: /bin/bash
    - gid_from_name: True
    - require:
      - group: pypi
  pip.installed:
    - name: pypiserver
    - require:
      - user: pypi
  file.directory:
    - name: /var/local/pypi/packages:
    - user: pypi
    - group: pypi
    - recurse:
      - user
      - group
    - require:
      - user: pypi
  file.managed:
    - name: /etc/init.d/pypiserver
    - source: salt://pypi/pypiserver.init
    - mode: 755
  file.managed:
    - name: /etc/default/pypiserver
    - source: salt://pypi/pypiserver.conf
  service.running:
    - name: pypiserver
    - enabled: True
    - require:
      - file: /var/local/pypi/packages
      - file: /etc/init.d/pypiserver
      - file: /etc/default/pypiserver

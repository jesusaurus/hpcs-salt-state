include:
  - git

devstack:
  git.latest:
    - name: https://github.com/openstack-dev/devstack.git
    - rev: stable/folsom
    - target: {{ pillar['devstack']['path'] }}
    - runas: ubuntu
    - force: True
    - require:
      - pkg: git
      - file: {{ pillar['devstack']['path'] }}
  cmd.wait:
    - name: {{ pillar['devstack']['path'] }}/stack.sh
    - cwd: {{ pillar['devstack']['path'] }}
    - user: ubuntu
    - require:
      - file: {{ pillar['devstack']['path'] }}/localrc
      - file: {{ pillar['devstack']['path'] }}/local.sh
    - watch:
      - git: devstack

{{ pillar['devstack']['path'] }}:
  file.directory:
    - user: ubuntu

{{ pillar['devstack']['path'] }}/localrc:
  file.managed:
    - source: salt://devstack/localrc
    - template: jinja
    - user: ubuntu
    - require:
      - git: devstack

{{ pillar['devstack']['path'] }}/local.sh:
  file.managed:
    - source: salt://devstack/local.sh
    - template: jinja
    - user: ubuntu
    - mode: 755
    - require:
      - file: {{ pillar['devstack']['path'] }}/precise.img
      - file: {{ pillar['devstack']['path'] }}/f17.img

{{ pillar['devstack']['path'] }}/precise.img:
  file.managed:
    - source: http://uec-images.ubuntu.com/precise/current/precise-server-cloudimg-amd64-disk1.img
    - source_hash: md5=38116cb5ea396e51d6b36e27f01dd156
    - user: ubuntu
    - require:
      - git: devstack

{{ pillar['devstack']['path'] }}/f17.img:
  file.managed:
    - source: http://berrange.fedorapeople.org/images/2012-11-15/f17-x86_64-openstack-sda.qcow2
    - source_hash: md5=1f104b5667768964d5df8c4ad1d7cd27
    - user: ubuntu
    - require:
      - git: devstack

include:
  - java

jenkins:
  user.present:
    - home: /home/jenkins
    - shell: /bin/sh
    - gid_from_name: True
    - require:
      - group: jenkins
  group:
    - present

{{ pillar['pubkeys']['jenkins_master']['key'] }}:
  ssh_auth:
    - present
    - user: jenkins
    - enc: {{ pillar['pubkeys']['jenkins_master']['enc'] }}
    - comment: {{ pillar['pubkeys']['jenkins_master']['comment'] }}
    - require:
      - user: jenkins

build_env:
  pkg.installed:
    - name: maven
  pkg.installed:
    - name: python-virtualenv
  {% if grains['os_family'] == 'Debian' %}
  pkg.installed:
    - name: build-essential
  pkg.installed:
    - name: python-dev
  {% elif grains['os_family'] == 'RedHat' %}
  pkg.installed:
    - name: python-devel
  pkg.installed:
    - name: gcc
  pkg.installed:
    - name: gcc-c++
  pkg.installed:
    - name: make
  pkg.installed:
    - name: autoconf
  pkg.installed:
    - name: pkgconfig
  pkg.installed:
    - name: libtool
  {% endif %}

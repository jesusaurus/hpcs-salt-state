include:
  - jenkins.slave

extra_build:
  pkg.installed:
    - name: bc
  pkg.installed:
    - name: debhelper
  pkg.installed:
    - name: libmysqlclient-dev
  pkg.installed:
    - name: libxslt1-dev
  pkg.installed:
    - name: python-pexpect
  pkg.installed:
    - name: python-pycurl
  pkg.installed:
    - name: reprepro

/home/jenkins/.pypirc:
  file.managed:
    - user: jenkins
    - mode: 600
    - source: salt://jenkins/dbaas-pypirc
    - template: jinja


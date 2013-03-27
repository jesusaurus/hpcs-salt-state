include:
  - git
  - jenkins.slave

java_sdk:
  pkg.installed:
    - name: {{ pillar['package']['java_sdk'] }}

/home/jenkins/.m2:
  file.directory:
    - user: jenkins
    - group: jenkins
    - mode: 750
    - require:
      - user: jenkins

/home/jenkins/.m2/settings.xml:
  file.managed:
    - user: jenkins
    - group: jenkins
    - mode: 640
    - template: jinja
    - source: salt://jenkins/msgaas-settings.xml
    - require:
      - user: jenkins
      - file: /home/jenkins/.m2

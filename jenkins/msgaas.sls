include:
  - git
  - jenkins.slave

java_sdk:
  pkg.installed:
    - name: {{ pillar['java_sdk'] }}

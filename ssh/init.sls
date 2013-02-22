ssh:
  pkg.installed:
    - name: {{ pillar['git'] }}

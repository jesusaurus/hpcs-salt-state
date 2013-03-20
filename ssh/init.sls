ssh:
  pkg.installed:
    - name: {{ pillar['ssh'] }}

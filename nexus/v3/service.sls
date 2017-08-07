# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "nexus/map.jinja" import nexus with context %}

nexus_service_init:
  file.managed:
    - name: '/etc/systemd/system/nexus.service'
    - source: salt://nexus/v3/files/nexus.service.jinja
    - template: jinja
    - context:
      nexus: {{nexus|yaml}}
    - mode: 655
    - user: root
    - group: root

nexus_service__service:
  service.running:
    - name: nexus
    - enable: True

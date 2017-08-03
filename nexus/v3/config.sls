# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "nexus/map.jinja" import nexus with context %}

nexus_config_setnexusproperties:
  file.managed:
    - name: {{ nexus.install.datapath }}/nexus3/etc/nexus.properties
    - source: salt://nexus/v3/files/nexus.properties.jinja
    - template: jinja
    - context:
      nexus: {{nexus|yaml}}
    - mode: 644
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}

nexus_config_jetty:
  file.managed:
    - name: {{ nexus.install.path }}/nexus/etc/jetty/jetty-https.xml
    - source: salt://nexus/v3/files/jetty-https.xml.jinja
    - template: jinja
    - context:
      nexus: {{nexus|yaml}}
    - mode: 644
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}

nexus_config_rc:
  file.managed:
    - name: {{ nexus.install.path }}/nexus/bin/nexus.rc
    - source: salt://nexus/v3/files/nexus.rc.jinja
    - template: jinja
    - context:
      nexus: {{nexus|yaml}}
    - mode: 644
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}

nexus_config_vmoptions:
  file.managed:
    - name: {{ nexus.install.path }}/nexus/bin/nexus.vmoptions
    - source: salt://nexus/v3/files/nexus.vmoptions.jinja
    - template: jinja
    - context:
      nexus: {{nexus|yaml}}
    - mode: 644
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}

nexus_add_bashrc_homedirectory:
  file.append:
    - name: /home/{{ nexus.user.name }}/.bashrc
    - text: {{ nexus.user.environmentvariable }}

nexus_config_rcfile:
  file.managed:
    - name: {{ nexus.install.path }}/nexus/bin/nexus.rc
    - source: salt://nexus/v3/files/nexus.rc.jinja
    - template: jinja
    - context:
      nexus: {{nexus|yaml}}
    - mode: 644
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}    
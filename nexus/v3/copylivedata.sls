# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "nexus/map.jinja" import nexus with context %}

nexus_prepare_copy_livedata:
  cmd.run:
    - name: 'rm -rf {{ nexus.install.datapath }}/nexus3/*/'
    - unless: 'test -f {{ nexus.download.hostpath }}/copied-{{ nexus.download.version }}.txt'

nexus_copy_livedata:
  cmd.run:
    - name: 'rsync -av {{ nexus.datacopy.originuser }}@{{ nexus.datacopy.originhost }}:{{ nexus.datacopy.originpath }}/ {{ nexus.install.datapath }}/nexus3/'
    - unless: 'test -f {{ nexus.download.hostpath }}/copied-{{ nexus.download.version }}.txt'

nexus_finish_copy_livedata:
  file.touch:
    - name: '{{ nexus.download.hostpath }}/copied-{{ nexus.download.version }}.txt'
    - require:
      - cmd: nexus_copy_livedata
    - unless: 'test -f {{ nexus.download.hostpath }}/copied-{{ nexus.download.version }}.txt'

nexus_datapath_take_ownership:
  file.directory:
    - name: {{ nexus.install.datapath }}
    - dir_mode: 755
    - file_mode: 644
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}
    - recurse:
      - user
      - group
    - require:
      - file: nexus_finish_copy_livedata

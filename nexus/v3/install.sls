# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "nexus/map.jinja" import nexus with context %}

nexus_install_user:
  user.present:
    - name: {{ nexus.user.name }}
    - home: {{ nexus.user.home }}
    - system: True

nexus_create_download_folder:
  file.directory:
    - name: {{ nexus.download.hostpath }}
    - dir_mode: 755
    - file_mode: 644
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}
    - recurse:
      - user
      - group
    - require:
        - user: nexus_install_user
    - if_missing: {{ nexus.download.hostpath }}

nexus_extract_home_download:
  archive.extracted:
    - name: {{ nexus.download.hostpath }}
    - source: {{ nexus.download.httppath }}
    - source_hash: {{ nexus.download.hash }}
    - keep: True
    - archive_format: tar
    - if_missing: {{ nexus.download.hostpath }}/nexus-{{ nexus.download.version }}.txt

{% if not salt['file.directory_exists' ]('{{ nexus.install.path }}/nexus-{{ nexus.download.version }}') %}
nexus_install_nexus:
  cmd.run:
    - name: 'cp -R {{ nexus.download.hostpath }}/nexus-{{ nexus.download.version }} {{ nexus.install.path }}'
    - require:
      - archive: nexus_extract_home_download
    - unless: 'test -f {{ nexus.install.path }}/nexus-{{ nexus.download.version }}/bin/nexus'
{% endif %}

{% if not salt['file.directory_exists' ]('{{ nexus.install.datapath }}') %}
nexus_install_data:
  cmd.run:
    - name: 'cp -R {{ nexus.download.hostpath }}/sonatype-work {{ nexus.install.datapath }}'
    - require:
      - archive: nexus_extract_home_download
    - unless: 'test -f {{ nexus.install.datapath }}/nexus3/etc/nexus.properties'
{% endif %}

nexus_mark_version_as_installed:
  cmd.run:
    - name: 'touch {{ nexus.download.hostpath }}/nexus-{{ nexus.download.version }}.txt'
    - unless: 'test -f {{ nexus.download.hostpath }}/nexus-{{ nexus.download.version }}.txt'
    - require:
      - archive: nexus_extract_home_download

nexus_install_opt_sonatype_etc:
    file.directory:
    - name: {{ nexus.install.path }}
    - dir_mode: 755
    - file_mode: 644
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}
    - recurse:
      - user
      - group

{% if not salt['file.directory_exists' ]('{{ nexus.install.datapath }}/nexus3/etc') %}
nexus_install_opt_nexus_takeownership:
  file.directory:
    - name: {{ nexus.install.datapath }}/nexus3/etc
    - dir_mode: 755
    - file_mode: 644
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}
    - recurse:
      - user
      - group
{% endif %}

nexus_install_takeownership_datapath:
  file.directory:
    - name: {{ nexus.install.datapath }}
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}
    - recurse:
      - user
      - group

{% if not salt['file.directory_exists' ]('{{ nexus.install.path }}/nexus') %}
symlink:
  file.symlink:
    - name: {{ nexus.install.path }}/nexus
    - target: {{ nexus.install.path }}/nexus-{{ nexus.download.version }}
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}
    - dir_mode: 755
    - file_mode: 644
{% endif %}

{% if not salt['file.directory_exists' ]('{{ nexus.install.path }}/sonatype-work') %}
data-symlink:
  file.symlink:
    - name: {{ nexus.install.path }}/sonatype-work
    - target: {{ nexus.install.datapath }}
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}
    - dir_mode: 755
    - file_mode: 644
{% endif %}

{% if nexus.file.nexus.properties.applicationportssl is defined %}
nexus_create_javakeystore:
  cmd.run:
    - name: '{{ nexus.java.home }}/bin/keytool -genkey -keyalg RSA -alias jetty -keystore {{ nexus.install.path }}/nexus/etc/ssl/{{ nexus.file.nexus.jetty.https.keystorepath }}.jks -storepass {{ nexus.file.nexus.jetty.https.keymanagerpassword }} -validity 720 -keysize 2048 -dname "cn={{ nexus.file.nexus.jetty.https.certificate.commonname }}, ou={{ nexus.file.nexus.jetty.https.certificate.ou }}, o={{ nexus.file.nexus.jetty.https.certificate.organisation }}, c={{ nexus.file.nexus.jetty.https.certificate.country }}" -keypass {{ nexus.file.nexus.jetty.https.keystorepassword }}'
    - require:
      - file: symlink
    - unless: test -f {{ nexus.install.path }}/nexus/etc/ssl/{{ nexus.file.nexus.jetty.https.keystorepath }}.jks

nexus_set_owernship_javakeystore:  
  file.directory:
    - name: {{ nexus.install.path }}/nexus/etc/ssl
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}
    - recurse:
      - user
      - group
{% endif %}

# -*- coding: utf-8 -*-
# vim: ft=sls
# GitHub: https://github.com/sonatype-nexus-community/nexus-repository-apt
# Sonatype Documentation: http://exchange.sonatype.com/details?extension=4719699238

{% from "nexus/map.jinja" import nexus with context %}

{% set nexus_core_features_xml = nexus.install.path + "/nexus/system/org/sonatype/nexus/assemblies/nexus-core-feature/" + nexus.download.version + "/nexus-core-feature-" + nexus.download.version + "-features.xml" %}

{% set commons_compress_version = salt["cmd.shell"]("grep -m 1 commons-compress " + nexus_core_features_xml + " | sed -e 's/.*commons-compress\/\(.*\)<\/b.*/\\1/'" ) %}

Download the plugin:
  file.managed:
    - name: {{ nexus.install.path }}/nexus/system/net/staticsnow/nexus-repository-apt/{{ nexus.plugins.nexus_repository_apt.version }}/nexus-repository-apt-{{ nexus.plugins.nexus_repository_apt.version }}.jar
    - source: {{ nexus.plugins.nexus_repository_apt.path }} 
    - keep: True
    - user: {{ nexus.user.name }}
    - group: {{ nexus.user.group }}
    - mode: 644
    - dir_mode: 755
    - makedirs: True
    - follow_symlinks: true
    - replace: False

Add specification to nexus-core-feature:
  file.line:
    - name: {{ nexus_core_features_xml }}
    - content: <feature prerequisite="false" dependency="false">nexus-repository-apt</feature>
    - mode: ensure
    - after: <feature version="{{ nexus.download.version | replace('-','.') }}" prerequisite="false" dependency="false">nexus-repository-maven</feature>
    - indent: True

Add specification to nexus-core-features list:
  file.line:
    - name: {{ nexus_core_features_xml }}
    - content: '
        <feature name="nexus-repository-apt" description="net.staticsnow:nexus-repository-apt" version="{{ nexus.plugins.nexus_repository_apt.version }}">
          <details>net.staticsnow:nexus-repository-apt</details>
          <bundle>mvn:net.staticsnow/nexus-repository-apt/{{ nexus.plugins.nexus_repository_apt.version }}</bundle>
          <bundle>mvn:org.apache.commons/commons-compress/{{ commons_compress_version }}</bundle>
        </feature>'
    - mode: ensure
    - before: <\/features>
    - indent: True

# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - nexus.v3.install
  - nexus.v3.config
  - nexus.v3.service
{%- if pillar.nexus.plugins is defined %}

 {%- if pillar.nexus.plugins.nexus_repository_apt is defined %}
  - nexus.v3.plugins.nexus-repository-apt
 {% endif %}

{% endif %}

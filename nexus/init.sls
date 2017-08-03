# -*- coding: utf-8 -*-
# vim: ft=sls

#using v3
{% if nexus.download.version %}
include:
  - nexus.v3.install
  - nexus.v3.config
  - nexus.v3.service
{% endif %}

#using v2
{% if nexus.version %}
include:
  - nexus.v2.init
{% endif %}
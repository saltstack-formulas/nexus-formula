# -*- coding: utf-8 -*-
# vim: ft=sls

{% if nexus.version %}
include:
  - nexus.v2.init
{% endif %}  

{% if nexus.download.version %}
include:
  - nexus.v3.install
  - nexus.v3.config
  - nexus.v3.service
{% endif %}  

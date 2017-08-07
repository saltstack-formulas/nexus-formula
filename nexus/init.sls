# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "nexus/map.jinja" import nexus with context %}

#using v3
{% if nexus.download.version is defined %}
include:
  - nexus.v3.init
{% endif %}

#using v2
{% if nexus.version is defined %}
include:
  - nexus.v2.init
{% endif %}
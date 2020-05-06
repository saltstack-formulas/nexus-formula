# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "nexus/map.jinja" import nexus with context %}

include:

{% set major_version = nexus.download.version %}

#using v3
{% if major_version[0] == '3'  %}
  - nexus.v3.init
{% endif %}

#using v2
{% if major_version[0] == '2'  %}
  - nexus.v2.init
{% endif %}

nginx:
  pkg.installed

{%- from 'nexus/settings.sls' import nexus with context %}

/etc/nginx/conf.d/nexus.conf:
  file.managed:
    - source: salt://nexus/nginx/conf/nexus.conf.nginx
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      nexus_server_name: {{ nexus.server_name }}
      nexus_port: {{ nexus.port }}

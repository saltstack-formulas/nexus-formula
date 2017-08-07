{% set p  = salt['pillar.get']('nexus', {}) %}
{% set pc = p.get('config', {}) %}
{% set g  = salt['grains.get']('nexus', {}) %}
{% set gc = g.get('config', {}) %}

{%- set host = salt['mine.get']('roles:nexus', 'network.interfaces', 'grain').keys()|first() %}

{%- if host is not defined %}
{%- set host = 'nexus' %}
{%- endif %}


{%- set version   = g.get('version', p.get('version', '2.14.2-01')) %}
{%- set prefix    = g.get('prefix', p.get('prefix', '/srv/nexus')) %}
{%- set home      = prefix + '/nexus' %}
{%- set real_home = home + '-' + version %}
{%- set workdir   = g.get('workdir', p.get('workdir', '/srv/nexus/sonatype_work')) %}
{%- set piddir    = g.get('piddir', p.get('piddir', '/var/run/nexus')) %}
{%- set username  = g.get('username', p.get('username', 'nexus')) %}
{%- set group     = g.get('group', p.get('group', 'nexus')) %}
{%- set port      = gc.get('port', pc.get('port', '8081')) %}
{%- set server_name = gc.get('server_name', pc.get('server_name', grains.get('fqdn'))) %}

{%- set source_url = g.get('source_url', p.get('source-url', 'http://www.sonatype.org/downloads/nexus-' + version + '-bundle.tar.gz')) %}

{%- set nexus = {} %}
{%- do nexus.update( {
                          'prefix'         : prefix,
                          'workdir'        : workdir,
                          'piddir'         : piddir,
                          'username'       : username,
                          'group'          : group,
                          'port'           : port,
                          'source_url'     : source_url,
                          'home'           : home,
                          'real_home'      : real_home,
                          'server_name'    : server_name,
                          'download_dir'   : '/tmp/nexus_download',
                     }) %}

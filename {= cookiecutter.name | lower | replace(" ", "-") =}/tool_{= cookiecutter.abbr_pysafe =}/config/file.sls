# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

{%- for user in {= cookiecutter.abbr_pysafe =}.users | selectattr('config', 'defined') | selectattr('config') %}

{= cookiecutter.name =} config file is managed for user '{{ user.name }}':
  file.managed:
    - name: {{ user['_' ~ tplroot[5:]].confdir | path_join(tplroot[5:], user['_' ~ tplroot[5:]].conffile) }}
    - source: {{ files_switch([user['_' ~ tplroot[5:]].conffile],
                              lookup='{= cookiecutter.name =} config file is managed for user \'{{ user.name }}\''
                 )
              }}
    - mode: '0600'
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: True
    - dir_mode: '0700'
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        user: {{ user | json }}
{%- endfor %}

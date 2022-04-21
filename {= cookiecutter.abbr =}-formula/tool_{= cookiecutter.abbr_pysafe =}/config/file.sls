# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}


{%- for user in {= cookiecutter.abbr_pysafe =}.users | selectattr('{= cookiecutter.abbr_pysafe =}.config', 'defined') | selectattr('{= cookiecutter.abbr_pysafe =}.config') %}

{= cookiecutter.name =} config file is managed for user '{{ user.name }}':
  file.managed:
    - name: {{ user['_{= cookiecutter.abbr_pysafe =}'].conffile }}
    - source: {{ files_switch([{= cookiecutter.abbr_pysafe =}.lookup.paths.conffile],
                              lookup="{= cookiecutter.name =} config file is managed for user '{}'".format(user.name),
                              opt_prefixes=[user.name])
              }}
    - mode: '0600'
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: true
    - dir_mode: '0700'
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        user: {{ user | json }}
{%- endfor %}

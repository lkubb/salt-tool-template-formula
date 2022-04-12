# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

include:
  - {{ sls_package_install }}


{%- for user in {= cookiecutter.abbr_pysafe =}.users | selectattr('completions', 'defined') | selectattr('completions') %}

Completions directory for {= cookiecutter.name =} is available for user '{{ user.name }}':
  file.directory:
    - name: {{ user.home | path_join(user.completions) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true

{= cookiecutter.name =} shell completions are available for user '{{ user.name }}':
  cmd.run:
    - name: {= cookiecutter.abbr =} --completions {{ user.shell }} > {{ user.home | path_join(user.completions, '_{= cookiecutter.abbr =}') }}
    - creates: {{ user.home | path_join(user.completions, '_{= cookiecutter.abbr =}') }}
    - onchanges:
      - {= cookiecutter.name =} is installed
    - runas: {{ user.name }}
    - require:
      - {= cookiecutter.name =} is installed
      - Completions directory for {= cookiecutter.name =} is available for user '{{ user.name }}'
{%- endfor %}

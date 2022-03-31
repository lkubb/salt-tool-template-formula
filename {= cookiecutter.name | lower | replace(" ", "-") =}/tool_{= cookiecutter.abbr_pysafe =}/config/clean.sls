# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{!- if 'y' == cookiecutter.has_service !}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{!- endif !}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{!- if 'y' == cookiecutter.has_service !}

include:
  - {{ sls_service_clean }}
{!- endif !}


{%- for user in {= cookiecutter.abbr_pysafe =}.users | selectattr('config', 'defined') | selectattr('config') %}

{= cookiecutter.name =} config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_{= cookiecutter.abbr_pysafe =}'].conffile }}
{!- if 'y' == cookiecutter.has_service !}
    - require:
      - sls: {{ sls_service_clean }}
{!- endif !}
{%- endfor %}


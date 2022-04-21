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


{%- for user in {= cookiecutter.abbr_pysafe =}.users {! if 'y' == cookiecutter.has_config_template !}| selectattr('{= cookiecutter.abbr_pysafe =}.config', 'defined') | selectattr('{= cookiecutter.abbr_pysafe =}.config') {! endif !}%}

{= cookiecutter.name =} config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_{= cookiecutter.abbr_pysafe =}'].conffile }}
{!- if 'y' == cookiecutter.has_service !}
    - require:
      - sls: {{ sls_service_clean }}
{!- endif !}

{!- if 'n' == cookiecutter.has_conffile_only or 'y' == cookiecutter.has_xdg !}
{!-   if 'y' == cookiecutter.has_xdg and 'y' == cookiecutter.needs_xdg_help !}

{%-   if user.xdg %}
{!-   endif !}

{= cookiecutter.name =} config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_{= cookiecutter.abbr_pysafe =}'].confdir }}
{!-   if 'y' == cookiecutter.has_xdg and 'y' == cookiecutter.needs_xdg_help !}
{%-   endif %}
{!-   endif !}
{!- endif !}
{%- endfor %}

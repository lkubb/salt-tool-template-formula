# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{!- if 'y' == cookiecutter.has_configsync or 'y' == cookiecutter.has_config_template !}
{%- set sls_config_file = tplroot ~ '.config' %}
{!- endif !}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{!- if 'y' == cookiecutter.has_configsync or 'y' == cookiecutter.has_config_template !}

include:
  - {{ sls_config_file }}
{!- endif !}


{= cookiecutter.name =} service is running:
  service.running:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.service.name }}
    - enable: true
{!- if 'y' == cookiecutter.has_configsync or 'y' == cookiecutter.has_config_template !}
    - watch:
      - sls: {{ sls_config_file }}
{!- endif !}

# -*- coding: utf-8 -*-
# vim: ft=sls
{!- if 'y' == cookiecutter.has_configsync !}

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}
{!- endif !}

include:
{!- if 'y' == cookiecutter.has_configsync !}
  - .sync
{!- endif !}
{!- if 'y' == cookiecutter.has_config_template !}
  - .file
{!- endif !}

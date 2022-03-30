# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

include:
  - .package
{%- if {= cookiecutter.abbr =}.users | rejectattr('xdg', 'sameas', False) | list %}
  - .xdg
{%- endif %}
{%- if {= cookiecutter.abbr =}.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') | list %}
  - .configsync
{%- endif %}

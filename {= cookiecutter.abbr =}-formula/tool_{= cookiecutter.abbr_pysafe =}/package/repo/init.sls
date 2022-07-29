# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

include:
{%- if {= cookiecutter.abbr_pysafe =}.lookup.pkg.manager in ['apt', 'dnf', 'yum', 'zypper'] %}
  - {{ slsdotpath }}.install
{%- elif salt['state.sls_exists'](slsdotpath ~ '.' ~ {= cookiecutter.abbr_pysafe =}.lookup.pkg.manager) %}
  - {{ slsdotpath }}.{{ {= cookiecutter.abbr_pysafe =}.lookup.pkg.manager }}
{%- else %}
  []
{%- endif %}

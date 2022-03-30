# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{#- brew automatically taps required repositories #}
{%- if 'Darwin' != grains['kernel'] %}
include:
{%-   if {= cookiecutter.abbr_pysafe =}.pkg.manager in ['apt', 'dnf', 'yum', 'zypper'] %}
  - {{ slsdotpath }}.install
{%-   elif salt['state.sls_exists'](slsdotpath ~ '.' ~ {= cookiecutter.abbr_pysafe =}.pkg.manager) %}
  - {{ slsdotpath }}.{{ {= cookiecutter.abbr_pysafe =}.pkg.manager }}
{%-   else %}
  {}
{%-   endif %}
{%- endif %}

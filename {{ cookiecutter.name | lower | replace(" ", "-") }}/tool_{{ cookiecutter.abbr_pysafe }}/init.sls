# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

include:
  - .package
{%- if {% endraw %}{{ cookiecutter.abbr }}{% raw %}.users | rejectattr('xdg', 'sameas', False) | list %}
  - .xdg
{%- endif %}
{%- if {% endraw %}{{ cookiecutter.abbr }}{% raw %}.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') | list %}
  - .configsync
{%- endif %}
{%- endraw %}

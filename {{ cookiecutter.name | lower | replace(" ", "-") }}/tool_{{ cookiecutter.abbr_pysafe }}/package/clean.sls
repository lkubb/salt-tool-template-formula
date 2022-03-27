# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

include:
  - {{ sls_config_clean }}

{% endraw %}{{ cookiecutter.name }}{% raw %} is removed:
  pkg.removed:
    - name: {{ {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}{% endraw %}

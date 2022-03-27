# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

include:
  - {{ sls_config_file }}

tool-{% endraw %}{{ cookiecutter.abbr }}{% raw %}-service-running-service-running:
  service.running:
    - name: {{ {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.service.name }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
      - sls: {{ tplroot ~ '.configsync' }}{% endraw %}

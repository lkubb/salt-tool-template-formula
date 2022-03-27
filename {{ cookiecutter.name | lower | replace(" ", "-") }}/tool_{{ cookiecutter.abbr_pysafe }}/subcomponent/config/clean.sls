# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

include:
  - {{ sls_service_clean }}

tool-{% endraw %}{{ cookiecutter.abbr }}{% raw %}-subcomponent-config-clean-file-absent:
  file.absent:
    - name: {{ {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.subcomponent.config }}
    - watch_in:
        - sls: {{ sls_service_clean }}{% endraw %}

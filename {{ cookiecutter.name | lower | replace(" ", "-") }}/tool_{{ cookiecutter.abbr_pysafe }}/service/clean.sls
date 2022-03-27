# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

tool-{% endraw %}{{ cookiecutter.abbr }}{% raw %}-service-clean-service-dead:
  service.dead:
    - name: {{ {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.service.name }}
    - enable: False{% endraw %}

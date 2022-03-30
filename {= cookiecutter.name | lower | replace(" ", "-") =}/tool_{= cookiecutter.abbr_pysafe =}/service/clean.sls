# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

tool-{= cookiecutter.abbr =}-service-clean-service-dead:
  service.dead:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.service.name }}
    - enable: False

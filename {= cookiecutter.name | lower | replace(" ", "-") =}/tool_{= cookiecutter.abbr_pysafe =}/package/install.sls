# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

include:
  - {{ slsdotpath }}.repo

{= cookiecutter.name =} is installed:
  pkg.installed:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.pkg.name }}
    - version: {{ {= cookiecutter.abbr_pysafe =}.get('version') or 'latest') }}
    {#- do not specify alternative return value to be able to unset default version #}

{= cookiecutter.name =} setup is completed:
  test.nop:
    - name: Hooray, {= cookiecutter.name =} setup has finished.
    - require:
      - pkg: {{ {= cookiecutter.abbr_pysafe =}.lookup.pkg.name }}

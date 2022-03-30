# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{%- for reponame, repodata in {= cookiecutter.abbr_pysafe =}.lookup.pkg.repos.items() %}
{= cookiecutter.name =} {{ reponame }} repository is absent:
  pkgrepo.absent:
{%-   for conf in ['name', 'ppa', 'ppa_auth', 'keyid', 'keyid_ppa', 'copr'] %}
{%-     if conf in repodata %}
    - {{ conf }}: {{ repodata[conf] }}
{%-     endif %}
{%-   endfor %}
    - require_in:
      - {= cookiecutter.name =} is installed
{%- endfor %}

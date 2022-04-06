# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}


{%- if {= cookiecutter.abbr_pysafe =}.lookup.pkg.manager not in ['apt', 'dnf', 'yum', 'zypper'] %}
{%-   if salt['state.sls_exists'](slsdotpath ~ '.' ~ {= cookiecutter.abbr_pysafe =}.lookup.pkg.manager ~ '.clean') %}

include:
  - {{ slsdotpath ~ '.' ~ {= cookiecutter.abbr_pysafe =}.lookup.pkg.manager ~ '.clean' }}
{%-   endif %}

{%- else %}

{%-   for reponame, repodata in {= cookiecutter.abbr_pysafe =}.lookup.pkg.repos.items() %}

{= cookiecutter.name =} {{ reponame }} repository is absent:
  pkgrepo.absent:
{%-     for conf in ['name', 'ppa', 'ppa_auth', 'keyid', 'keyid_ppa', 'copr'] %}
{%-       if conf in repodata %}
    - {{ conf }}: {{ repodata[conf] }}
{%-       endif %}
{%-     endfor %}
{%-   endfor %}
{%- endif %}

# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{%- if grains['os'] in ['Debian', 'Ubuntu'] %}
Ensure {= cookiecutter.name =} APT repository can be managed:
  pkg.installed:
    - pkgs:
      - python-apt                   # required by Salt
{%-   if 'Ubuntu' == grains['os'] %}
      - python-software-properties   # to better support PPA repositories
{%-   endif %}
{%- endif %}

{%- for reponame in {= cookiecutter.abbr_pysafe =}.lookup.pkg.enablerepo %}
{= cookiecutter.name =} {{ repo }} repository is available:
  pkgrepo.managed:
{%- for conf, val in {= cookiecutter.abbr_pysafe =}.lookup.pkg.repo[reponame].items() %}
    - {{ conf }}: {{ val }}
{%- endfor %}
{%- if {= cookiecutter.abbr_pysafe =}.lookup.pkg.manager in ['dnf', 'yum', 'zypper'] %}
    - enabled: 1
{%- endif %}
    - require_in:
      - {= cookiecutter.name =} is installed

{%- for reponame, repodata in {= cookiecutter.abbr_pysafe =}.lookup.pkg.repos.items() %}
{%-   if reponame not in {= cookiecutter.abbr_pysafe =}.lookup.pkg.enablerepo %}
{= cookiecutter.name =} {{ reponame }} repository is disabled:
  pkgrepo.absent:
{%-     for conf in ['name', 'ppa', 'ppa_auth', 'keyid', 'keyid_ppa', 'copr'] %}
{%-       if conf in repodata %}
    - {{ conf }}: {{ repodata[conf] }}
{%-       endif %}
{%-     endfor %}
    - require_in:
      - {= cookiecutter.name =} is installed
{%-   endif %}
{%- endfor %}

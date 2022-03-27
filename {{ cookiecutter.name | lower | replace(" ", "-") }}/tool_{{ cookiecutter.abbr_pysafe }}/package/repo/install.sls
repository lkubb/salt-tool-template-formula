# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

{%- if grains['os'] in ['Debian', 'Ubuntu'] %}
Ensure {% endraw %}{{ cookiecutter.name }}{% raw %} APT repository can be managed:
  pkg.installed:
    - pkgs:
      - python-apt                   # required by Salt
{%-   if 'Ubuntu' == grains['os'] %}
      - python-software-properties   # to better support PPA repositories
{%-   endif %}
{%- endif %}

{%- for reponame in {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.pkg.enablerepo %}
{% endraw %}{{ cookiecutter.name }}{% raw %} {{ repo }} repository is available:
  pkgrepo.managed:
{%- for conf, val in {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.pkg.repo[reponame].items() %}
    - {{ conf }}: {{ val }}
{%- endfor %}
{%- if {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.pkg.manager in ['dnf', 'yum', 'zypper'] %}
    - enabled: 1
{%- endif %}
    - require_in:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} is installed

{%- for reponame, repodata in {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.pkg.repos.items() %}
{%-   if reponame not in {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.pkg.enablerepo %}
{% endraw %}{{ cookiecutter.name }}{% raw %} {{ reponame }} repository is disabled:
  pkgrepo.absent:
{%-     for conf in ['name', 'ppa', 'ppa_auth', 'keyid', 'keyid_ppa', 'copr'] %}
{%-       if conf in repodata %}
    - {{ conf }}: {{ repodata[conf] }}
{%-       endif %}
{%-     endfor %}
    - require_in:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} is installed
{%-   endif %}
{%- endfor %}{% endraw %}

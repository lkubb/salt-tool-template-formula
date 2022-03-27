# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

{%- for reponame, repodata in {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.pkg.repos.items() %}
{% endraw %}{{ cookiecutter.name }}{% raw %} {{ reponame }} repository is absent:
  pkgrepo.absent:
{%-   for conf in ['name', 'ppa', 'ppa_auth', 'keyid', 'keyid_ppa', 'copr'] %}
{%-     if conf in repodata %}
    - {{ conf }}: {{ repodata[conf] }}
{%-     endif %}
{%-   endfor %}
    - require_in:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} is installed
{%- endfor %}{% endraw %}

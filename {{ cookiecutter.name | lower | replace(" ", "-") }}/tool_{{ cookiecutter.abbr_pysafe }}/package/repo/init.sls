# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

{#- brew automatically taps required repositories #}
{%- if 'Darwin' != grains['kernel'] %}
include:
{%-   if {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.pkg.manager in ['apt', 'dnf', 'yum', 'zypper'] %}
  - {{ slsdotpath }}.install
{%-   elif salt['state.sls_exists'](slsdotpath ~ '.' ~ {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.pkg.manager) %}
  - {{ slsdotpath }}.{{ {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.pkg.manager }}
{%-   else %}
  {}
{%-   endif %}
{%- endif %}{% endraw %}

# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

include:
  - {{ slsdotpath }}.repo

{% endraw %}{{ cookiecutter.name }}{% raw %} is installed:
  pkg.{{ mode }}:
    - name: {{ {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.pkg.name }}
    - version: {{ {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.pkg.get('version') or 'latest' }}
    {#- do not specify alternative return value to be able to unset default version #}

{% endraw %}{{ cookiecutter.name }}{% raw %} setup is completed:
  test.nop:
    - name: Hooray, {% endraw %}{{ cookiecutter.name }}{% raw %} setup has finished.
    - require:
      - pkg: {{ {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.pkg.name }}{% endraw %}

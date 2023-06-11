# vim: ft=sls

{#-
    Removes {= cookiecutter.abbr_pysafe =} completions for all managed users.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}


{%- for user in {= cookiecutter.abbr_pysafe =}.users | selectattr("completions", "defined") | selectattr("completions") %}

{= cookiecutter.name =} shell completions are absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user.home | path_join(user.completions, "_{= cookiecutter.abbr =}") }}
{%- endfor %}

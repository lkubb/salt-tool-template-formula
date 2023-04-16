# vim: ft=sls

{#-
    Ensures {= cookiecutter.name =} adheres to the XDG spec
    as best as possible for all managed users.
    Has a dependency on `tool_{= cookiecutter.abbr_pysafe =}.package`_.
#}

include:
  - .migrated

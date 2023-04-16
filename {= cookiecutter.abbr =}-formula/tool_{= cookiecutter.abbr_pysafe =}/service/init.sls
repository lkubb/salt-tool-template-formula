# vim: ft=sls

{#-
    Starts the {= cookiecutter.name =} service and enables it at boot time.
    Has a dependency on `tool_{= cookiecutter.abbr_pysafe =}.{= "config" if cookiecutter.has_config_template == "y" or cookiecutter.has_configsync == "y" else "package" =}`_.
#}

include:
  - .running

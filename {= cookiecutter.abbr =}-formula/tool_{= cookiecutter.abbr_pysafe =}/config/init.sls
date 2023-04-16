# -*- coding: utf-8 -*-
# vim: ft=sls

{#-
    Manages the {= cookiecutter.name =} {= "service" if cookiecutter.has_service == "y" else "package" =} configuration by
{!- if cookiecutter.has_configsync == "y" !}
    * recursively syncing from a dotfiles repo
{!- endif !}
{!- if cookiecutter.has_config_template == "y" !}
    * managing/serializing the config file{! if cookiecutter.has_configsync == "y" !} afterwards{! endif !}
{!- endif !}
    Has a dependency on `tool_{= cookiecutter.abbr_pysafe =}.package`_.
#}

include:
{!- if cookiecutter.has_configsync == "y" !}
  - .sync
{!- endif !}
{!- if cookiecutter.has_config_template == "y" !}
  - .file
{!- endif !}

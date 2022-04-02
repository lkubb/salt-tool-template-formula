# -*- coding: utf-8 -*-
# vim: ft=sls

include:
{!- if 'y' == cookiecutter.has_configsync !}
  - .sync
{!- endif !}
{!- if 'y' == cookiecutter.has_config_template !}
  - .file
{!- endif !}

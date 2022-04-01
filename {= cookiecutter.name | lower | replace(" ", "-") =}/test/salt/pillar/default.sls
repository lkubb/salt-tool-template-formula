# -*- coding: utf-8 -*-
# vim: ft=yaml
---
tool_global:
  users:
    user:
      configsync: true
      persistenv: .bash_profile
      rchook: .bashrc
      xdg: true
{!- if cookiecutter._usersettings !}
      {= cookiecutter.abbr_pysafe =}:
        {= cookiecutter._usersettings | yaml(False) | indent(8) =}
{!- endif !}
tool_{= cookiecutter.abbr_pysafe =}:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value

    pkg:
      name: {= cookiecutter.pkg =}
{!- if 'y' == cookiecutter.needs_repo !}
      enable_repo:
        - stable
{!- endif !}
    paths:
      confdir: '{= cookiecutter.default_confdir =}'
      conffile: '{= cookiecutter.default_conffile =}'
{!- if 'y' == cookiecutter.needs_xdg_help !}
      xdg_dirname: '{= cookiecutter.xdg_dirname =}'
      xdg_conffile: '{= cookiecutter.xdg_conffile =}'
{!- endif !}
{!- if 'y' == cookiecutter.has_service !}
    service:
      name: {= cookiecutter.pkg =}
{!- endif !}
{!- if cookiecutter._settings !}
  {= cookiecutter._settings | yaml(False) | indent(2) =}
{!- endif !}

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://tool_{= cookiecutter.abbr_pysafe =}/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   tool-{= cookiecutter.abbr =}-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

{!- if 'y' == cookiecutter.has_config_template !}

    # For testing purposes
    source_files:
      {= cookiecutter.name =} config file is managed for user 'user':
        - '{= cookiecutter.xdg_conffile =}'
        - '{= cookiecutter.xdg_conffile =}.jinja'
{!- endif !}

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value

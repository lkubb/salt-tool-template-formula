# -*- coding: utf-8 -*-
# vim: ft=yaml
---
tool_global:
  users:
    user:
      completions: .completions
      configsync: true
      persistenv: .bash_profile
      rchook: .bashrc
      xdg: true
{!- if cookiecutter.usersettings !}
      {= cookiecutter.abbr_pysafe =}:
        {= cookiecutter.usersettings | yaml(False) | indent(8) =}
{!- endif !}
tool_{= cookiecutter.abbr_pysafe =}:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value

    pkg:
      name: {= cookiecutter.pkg =}
{!- if 'pkg' in cookiecutter.lookup !}
      {= cookiecutter.lookup.pkg | yaml(False) | indent(6) =}
{!- endif !}
{!- if 'y' == cookiecutter.needs_repo !}
      enable_repo:
        - stable
{!- endif !}
    paths:
      confdir: '{= cookiecutter.default_confdir =}'
      conffile: '{= cookiecutter.default_conffile =}'
{!- if 'y' == cookiecutter.needs_xdg_help or 'y' == cookiecutter.has_xdg !}
      xdg_dirname: '{= cookiecutter.xdg_dirname =}'
      xdg_conffile: '{= cookiecutter.xdg_conffile =}'
{!- endif !}
{!- if 'paths' in cookiecutter.lookup !}
      {= cookiecutter.lookup.paths | yaml(False) | indent(6) =}
{!- endif !}
    rootgroup: root
{!- if 'y' == cookiecutter.has_service !}
    service:
      name: {= cookiecutter.pkg =}
{!-   if 'service' in cookiecutter.lookup !}
      {= cookiecutter.lookup.service | yaml(False) | indent(6) =}
{!-   endif !}
{!- endif !}
{!- for var, val in cookiecutter.lookup.items() !}
{!-   if var not in ["pkg", "service", "paths"] !}
    {= {var: val} | yaml(False) | indent(4) =}
{!-   endif !}
{!- endfor !}
{!- if cookiecutter.settings !}
  {= cookiecutter.settings | yaml(False) | indent(2) =}
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
        - '{= cookiecutter.xdg_conffile or cookiecutter.default_conffile =}'
        - '{= cookiecutter.xdg_conffile or cookiecutter.default_conffile =}.jinja'
{!- endif !}

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value

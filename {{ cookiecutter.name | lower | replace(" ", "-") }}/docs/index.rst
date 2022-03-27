{%- set h = 'Welcome to salt-tool-' ~ cookiecutter.abbr ~ '-formula\'s documentation!' -%}
{{ h }}
{{ '=' * h | length }}

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   README
   toolsuite
   states
   pillar
{%- if cookiecutter.modstate %}
   modules_execution/index
   modules_state/index
{%- endif %}
   map.jinja
   TOFS_pattern



Indices and tables
==================

* :ref:`genindex`
{%- if cookiecutter.modstate %}
* :ref:`modindex`
{%- endif %}
* :ref:`search`

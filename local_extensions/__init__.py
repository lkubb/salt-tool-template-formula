import collections
import yaml

from collections import OrderedDict
from jinja2.ext import Extension
from yaml import SafeDumper, Dumper

# this was taken from Salt directly, found in
# salt.utils.yamldumper
# needed to dump OrderedDict objects
class SafeOrderedDumper(SafeDumper):
    """
    A YAML safe dumper that represents python OrderedDict as simple YAML map.
    """


# this was taken from Salt directly, found in
# salt.utils.yamldumper
# fixes indents for lists
class IndentMixin(Dumper):
    """
    Mixin that improves YAML dumped list readability
    by indenting them by two spaces,
    instead of being flush with the key they are under.
    """

    def increase_indent(self, flow=False, indentless=False):
        return super().increase_indent(flow, False)


class IndentedSafeOrderedDumper(IndentMixin, SafeOrderedDumper):
    """
    A YAML safe dumper that represents python OrderedDict as simple YAML map,
    and also indents lists by two spaces.
    """


def represent_ordereddict(dumper, data):
    return dumper.represent_dict(list(data.items()))


def represent_undefined(dumper, data):
    return dumper.represent_scalar("tag:yaml.org,2002:null", "NULL")


# https://stackoverflow.com/questions/8640959/how-can-i-control-what-scalar-form-pyyaml-uses-for-my-data
def represent_str(dumper, data):
    if len(data.splitlines()) > 1:  # check for multiline string
        return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
    return dumper.represent_scalar('tag:yaml.org,2002:str', data)


SafeOrderedDumper.add_representer(OrderedDict, represent_ordereddict)
SafeOrderedDumper.add_representer(None, represent_undefined)
SafeOrderedDumper.add_representer(
    collections.defaultdict, yaml.representer.SafeRepresenter.represent_dict
)
SafeOrderedDumper.add_representer(str, represent_str)


class YAMLDumper(Extension):
    def __init__(self, environment):
        super(YAMLDumper, self).__init__(environment)
        environment.filters['yaml'] = self.dump_yaml

    def dump_yaml(self, data, flow_style=False, indent=0):
        ret = yaml.dump(data, Dumper=IndentedSafeOrderedDumper, indent=indent, default_flow_style=flow_style, canonical=False)
        if ret.endswith('...\n'):
            ret = ret[:-4]
        return ret.strip()

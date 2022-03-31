# -*- coding: utf-8 -*-

import collections
import yaml

from collections import OrderedDict
from jinja2.ext import Extension
from yaml import SafeDumper

# this was taken from Salt directly, found in
# salt.utils.yamldumper
# needed to dump OrderedDict objects
class SafeOrderedDumper(SafeDumper):
    """
    A YAML safe dumper that represents python OrderedDict as simple YAML map.
    """

def represent_ordereddict(dumper, data):
    return dumper.represent_dict(list(data.items()))


def represent_undefined(dumper, data):
    return dumper.represent_scalar("tag:yaml.org,2002:null", "NULL")

SafeOrderedDumper.add_representer(OrderedDict, represent_ordereddict)
SafeOrderedDumper.add_representer(None, represent_undefined)
SafeOrderedDumper.add_representer(
    collections.defaultdict, yaml.representer.SafeRepresenter.represent_dict
)

class YAMLDumper(Extension):
    def __init__(self, environment):
        super(YAMLDumper, self).__init__(environment)
        environment.filters['yaml'] = self.dump_yaml

    def dump_yaml(self, data, flow_style=False, indent=0):
        ret = yaml.dump(data, Dumper=SafeOrderedDumper, indent=indent, default_flow_style=flow_style, canonical=False)
        if ret.endswith('...\n'):
            ret = ret[:-4]
        return ret.strip()

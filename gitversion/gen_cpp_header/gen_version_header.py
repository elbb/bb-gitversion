#!/usr/bin/env python2

from jinja2 import Environment, FileSystemLoader
from collections import OrderedDict 
import json

file_loader = FileSystemLoader('template')
env = Environment(trim_blocks=True, lstrip_blocks=True, loader=file_loader) 

template = env.get_template('template_version.h')

# read file
with open('/gen/json/gitversion.json', 'r') as file:
    data=file.read()

# Closing file 
file.close() 

# returns JSON object as a dictionary 
dict = json.loads(data) 

# if you would like to delete empty version elements, use this peace of code
# empty_keys = [k for k,v in dict.iteritems() if len(str(v)) is 0]
# for k in empty_keys:
#     del dict[k]

# sort dict by key names
dict_sort = OrderedDict(sorted(dict.items()))

# generate header file 
template.stream(ver=dict_sort).dump("/gen/cpp/version.h")

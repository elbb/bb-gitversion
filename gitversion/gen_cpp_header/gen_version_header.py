#!/usr/bin/env python2

from jinja2 import Environment, FileSystemLoader
from collections import OrderedDict 
import json
import sys

file_loader = FileSystemLoader(sys.argv[1])
env = Environment(trim_blocks=True, lstrip_blocks=True, loader=file_loader) 

template = env.get_template(sys.argv[2])

# read file
with open(sys.argv[3], 'r') as file:
    data=file.read()

# Closing file 
file.close() 

# returns JSON object as a dictionary 
dict = json.loads(data) 

# generate header file 
template.stream(ver=dict).dump(sys.argv[4])

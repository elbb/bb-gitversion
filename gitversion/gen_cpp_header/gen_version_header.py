#!/usr/bin/env python2

from jinja2 import Environment, FileSystemLoader
from collections import OrderedDict 
import json
import sys
import os

file_loader = FileSystemLoader(os.path.dirname(sys.argv[1]))
env = Environment(trim_blocks=True, lstrip_blocks=True, loader=file_loader) 

template = env.get_template(os.path.basename(sys.argv[1]))

# read file
with open(sys.argv[2], 'r') as file:
    data=file.read()

# Closing file 
file.close() 

# returns JSON object as a dictionary 
dict = json.loads(data) 

# generate header file 
template.stream(ver=dict).dump(sys.argv[3])

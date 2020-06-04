#!/usr/bin/env python2

from jinja2 import Environment, FileSystemLoader
import sh

file_loader = FileSystemLoader('/tools/gen_cpp_header/template')
env = Environment(loader=file_loader)
env.trim_blocks = False
env.lstrip_blocks = False

template = env.get_template('template_version.h')

version = {}
version['major'] = sh.jq( "-r",".Major|tostring","/gen/json/gitversion.json")
version['minor'] = sh.jq( "-r",".Minor|tostring","/gen/json/gitversion.json")
version['patch'] = sh.jq( "-r",".Patch|tostring","/gen/json/gitversion.json")
version['semver'] = sh.jq( "-r",".SemVer","/gen/json/gitversion.json")
version['fullsemver'] = sh.jq( "-r",".FullSemVer","/gen/json/gitversion.json")
version['informationalversion'] = sh.jq( "-r",".InformationalVersion","/gen/json/gitversion.json")
version['branchname'] = sh.jq( "-r",".BranchName","/gen/json/gitversion.json")
version['shortsha'] = sh.jq( "-r",".ShortSha","/gen/json/gitversion.json")

template.stream(ver=version).dump("/gen/cpp/version.h")

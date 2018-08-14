#!/usr/bin/env python
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter, FileType
from jinja2 import Environment, FileSystemLoader, TemplateSyntaxError
from pathlib import Path
import json
import sys
import os

def build_api (ctx):
    '''ctx must have the following attributes:
    * ctx.template
    * ctx.input
    * ctx.output'''
    settings = dict(
        lstrip_blocks=True,
        trim_blocks=True,
        loader=FileSystemLoader(os.fsdecode(ctx.directory)),
        cache_size=0)
    env = Environment(**settings)
    with ctx.template as template, ctx.input as infile, ctx.output as outfile:
        template = env.from_string(template.read())
        try:
            stream = template.stream(**json.load(infile))
            stream.dump(outfile)
        except TemplateSyntaxError as e:
            print('{e.name}:{e.lineno} {e.message}'.format(e=e), file=sys.stderr)

if __name__ == '__main__':
    parser = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter)
    parser.add_argument(
        '-t', '--template',
        required=True,
        type=FileType('r'),
        help='Jinja2 Template File')
    parser.add_argument(
        '-d', '--directory',
        type=Path,
        help='Path to templates for loading')
    parser.add_argument(
        '-i', '--input',
        required=True,
        type=FileType('r'),
        help='JSON API Description File')
    parser.add_argument(
        '-o', '--output',
        required=True,
        type=FileType('w'),
        help='Output Filename')
    args = parser.parse_args()
    build_api(args)

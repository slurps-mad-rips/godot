from pathlib import Path
import sys
import os

from . import version

class Generator:
    def __init__ (self, env):
        self.env = env

    def root (self, path): return self.env.GetBuildPath('#/{}'.format(path))
    def depends (self, output, *args):
        for arg in args:
            self.env.Depends(output, arg)

    def doc_header (self, output, template, docs):
        args = dict(
            executable=sys.executable,
            template=self.root(template),
            script=self.docs_generator)
        command = '@"{executable}" {script} -o $TARGET -t "{template}" $SOURCES'
        result = self.env.Command(
            output,
            docs,
            command.format(**args),
            TEMPLATE=template)
        self.env.NoCache(result)
        self.depends(output, self.root(template), docs)
        return result

    # TODO: Turn into jinjafiable template
    def doc_data_class_path (self, path):
        length = len(self.env.doc_class_path)
        with open(os.path.join(path, 'doc_data_class_path.gen.h'), 'w') as out:
            out.write('struct _DocDataClassPath { const char* name; const char* path; };\n')
            out.write('static const int _doc_data_class_path_count = {};\n'.format(length))
            out.write('static const _DocDataClassPath _doc_data_class_paths[{}] = {{\n'.format(length + 1))
            for cls in sorted(self.env.doc_class_path):
                out.write('\t{{"{}","{}"}},\n'.format(cls, self.env.doc_class_path[cls]))
            out.write('\t{ }\n')
            out.write('};\n')

    def register_exporters (self):
        pass

    def translations (self): pass

    def fonts (self, output, template, fonts):
        args = dict(
            executable=sys.executable,
            template=self.root(template),
            script=self.font_generator)
        command = '@"{executable}" {script} -o $TARGET -t "{template}" $SOURCES'
        result = self.env.Command(
            output,
            fonts,
            command.format(**args))
        self.env.NoCache(result)
        self.depends(output, self.root(template), fonts)
        return result

    @property
    def font_generator (self):
        return self.root('scripts/editor-font-generator.py')

    @property
    def docs_generator (self):
        return self.root('scripts/editor-docs-generator.py')

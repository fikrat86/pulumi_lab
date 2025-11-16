import sys
import shutil

# Copy source file to destination (used as Pulumi editor)
if len(sys.argv) > 1:
    source = r"c:\Users\fikra\Documents\Lesson\Cloud_Computing\Fall semester\Implementing DevOps Solutions-1209\Labs\Pulumi\esc-definition.yaml"
    dest = sys.argv[1]
    shutil.copy(source, dest)
    print(f"Copied {source} to {dest}")

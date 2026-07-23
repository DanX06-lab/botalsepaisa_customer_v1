import re
from collections import defaultdict
import subprocess
import os

out = subprocess.run(['flutter.bat', 'analyze'], capture_output=True, text=True, shell=True).stdout

needs_colors = set()
needs_gradients = set()

for line in out.splitlines():
    # Looking for: The getter 'surfaceLight' isn't defined for the type 'AppColorsExtension'
    # or The getter 'gradients' isn't defined for the type 'BuildContext'
    # or Undefined name 'context'
    if 'undefined_getter' in line or 'undefined_identifier' in line:
        parts = line.strip().split(' - ')
        if len(parts) >= 4:
            path_info = parts[2]
            path_parts = path_info.split(':')
            if len(path_parts) >= 3:
                filepath = ':'.join(path_parts[:-2])
                if 'gradients' in line or 'Gradients' in line:
                    needs_gradients.add(filepath)
                if 'AppColors' in line or 'colors' in line or 'surfaceLight' in line:
                    needs_colors.add(filepath)
                if 'context' in line:
                    # 'context' might imply it needs both or it's a structural issue
                    pass

print(f"Colors needs in: {len(needs_colors)} files")
print(f"Gradients needs in: {len(needs_gradients)} files")

for filepath in needs_colors.union(needs_gradients):
    if not os.path.exists(filepath): continue
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Calculate relative path to core/theme/...
    # Split path by os.sep or '/'
    parts = filepath.replace('\\', '/').split('/')
    # find 'lib' index
    try:
        lib_idx = parts.index('lib')
        depth = len(parts) - lib_idx - 2 # -1 for filename, -1 for lib
        prefix = '../' * depth if depth > 0 else './'
        if depth == 0: prefix = '' # inside lib/ directly
        
        color_import = f"import '{prefix}core/theme/app_colors_extension.dart';"
        gradient_import = f"import '{prefix}core/theme/app_gradients_extension.dart';"
        
        lines = content.splitlines()
        # Find last import
        last_import = 0
        for i, l in enumerate(lines):
            if l.startswith('import '):
                last_import = i
        
        if filepath in needs_colors and 'app_colors_extension.dart' not in content:
            lines.insert(last_import + 1, color_import)
            
        if filepath in needs_gradients and 'app_gradients_extension.dart' not in content:
            lines.insert(last_import + 1, gradient_import)
            
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines) + '\n')
        print(f"Added imports to {filepath}")
    except ValueError:
        pass

import os, re, subprocess

def read_file(path):
    with open(path, 'r', encoding='utf-8') as f: return f.read()

def write_file(path, content):
    with open(path, 'w', encoding='utf-8') as f: f.write(content)

# Add gradients import to files that need it
gradient_files = [
    'lib/features/home/screens/home_screen.dart',
    'lib/features/onboarding/screens/splash_screen.dart',
    'lib/features/profile/screens/profile_screen.dart',
    'lib/features/profile/screens/refer_and_earn_screen.dart'
]

for f in gradient_files:
    if not os.path.exists(f): continue
    content = read_file(f)
    if 'app_gradients_extension.dart' not in content:
        lines = content.splitlines()
        for i, l in enumerate(lines):
            if l.startswith('import ') and 'flutter' in l:
                depth = f.count('/') - 1
                prefix = '../'*depth
                lines.insert(i+1, f"import '{prefix}core/theme/app_gradients_extension.dart';")
                break
        write_file(f, '\n'.join(lines) + '\n')

# Fix textSecondaryLight -> textSecondary
f = 'lib/features/onboarding/screens/onboarding_screen.dart'
if os.path.exists(f):
    c = read_file(f).replace('context.colors.textSecondaryLight', 'context.colors.textSecondary')
    c = c.replace('context.colors.borderLight', 'context.colors.border')
    write_file(f, c)

# Fix surfaceLight -> surface
f = 'lib/features/profile/screens/achievements_screen.dart'
if os.path.exists(f):
    write_file(f, read_file(f).replace('context.colors.surfaceLight', 'context.colors.surface'))

# Fix context to AppColors in home_screen.dart and profile_screen.dart
for f in ['lib/features/home/screens/home_screen.dart', 'lib/features/profile/screens/profile_screen.dart']:
    if not os.path.exists(f): continue
    c = read_file(f)
    c = re.sub(r'context\.colors\.([a-zA-Z0-9_]+)', r'AppColors.\1', c)
    if 'app_colors.dart' not in c and 'AppColors.' in c:
        c = c.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../../core/constants/app_colors.dart';")
    write_file(f, c)

# Fix constants again using flutter analyze output
out = subprocess.run(['flutter.bat', 'analyze'], capture_output=True, text=True, shell=True).stdout
lines_to_fix = {}
for line in out.splitlines():
    if 'invalid_constant' in line or 'non_constant_list_element' in line:
        parts = line.strip().split(' - ')
        if len(parts) >= 4:
            path_info = parts[2]
            path_parts = path_info.split(':')
            if len(path_parts) >= 3:
                filepath = ':'.join(path_parts[:-2])
                linenum = int(path_parts[-2])
                if filepath not in lines_to_fix: lines_to_fix[filepath] = set()
                lines_to_fix[filepath].add(linenum)

for filepath, lines in lines_to_fix.items():
    if not os.path.exists(filepath): continue
    content = read_file(filepath).splitlines()
    for l in lines:
        idx = l - 1
        if idx < len(content):
            content[idx] = re.sub(r'\bconst\b\s*', '', content[idx])
    write_file(filepath, '\n'.join(content) + '\n')

print('Done applying second round of fixes')

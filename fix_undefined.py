import os, re

def read_file(path):
    with open(path, 'r', encoding='utf-8') as f: return f.read()

def write_file(path, content):
    with open(path, 'w', encoding='utf-8') as f: f.write(content)

# Fix undefined gradients by adding import
files_with_gradients = [
    'lib/features/scanner/screens/bottle_details_screen.dart',
    'lib/features/scanner/screens/reward_success_screen.dart',
    'lib/features/wallet/screens/wallet_screen.dart',
    'lib/shared/widgets/primary_button.dart'
]

for f in files_with_gradients:
    content = read_file(f)
    if 'app_gradients_extension.dart' not in content:
        # Find imports
        lines = content.splitlines()
        for i, l in enumerate(lines):
            if l.startswith('import ') and 'flutter' in l:
                depth = f.count('/') - 1
                prefix = '../'*depth
                lines.insert(i+1, f"import '{prefix}core/theme/app_gradients_extension.dart';")
                break
        write_file(f, '\n'.join(lines) + '\n')

# Fix surfaceLight -> surface in report_problem_screen.dart
f = 'lib/features/settings/screens/report_problem_screen.dart'
content = read_file(f)
content = content.replace('context.colors.surfaceLight', 'context.colors.surface')
write_file(f, content)

# Fix textSecondaryLight -> textSecondary in active_sessions_screen.dart
f = 'lib/features/settings/screens/active_sessions_screen.dart'
content = read_file(f)
content = content.replace('context.colors.textSecondaryLight', 'context.colors.textSecondary')
write_file(f, content)

screens = [
    'lib/features/profile/screens/refer_and_earn_screen.dart',
    'lib/features/settings/screens/settings_screens.dart',
    'lib/features/settings/screens/contact_support_screen.dart',
    'lib/features/scanner/screens/bottle_details_screen.dart',
    'lib/features/scanner/screens/bottle_scanner_screen.dart',
    'lib/features/scanner/screens/scanner_screen.dart',
    'lib/features/settings/screens/active_sessions_screen.dart'
]

for f in screens:
    content = read_file(f)
    content = re.sub(r'context\.colors\.([a-zA-Z0-9_]+)', r'AppColors.\1', content)
    if 'app_colors.dart' not in content and 'AppColors.' in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../../core/constants/app_colors.dart';")
        content = content.replace("import '../../core/constants/app_colors.dart';", "") # remove if added wrong
    write_file(f, content)

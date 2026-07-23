import os

# Fix design_system.dart context
f = 'lib/core/constants/design_system.dart'
c = open(f, 'r', encoding='utf-8').read()
c = c.replace('context.colors.primary', 'AppColors.primary')
if 'app_colors.dart' not in c:
    c = c.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'app_colors.dart';")
with open(f, 'w', encoding='utf-8') as file: file.write(c)

# Fix app_theme.dart CardThemeData -> CardTheme
f = 'lib/core/theme/app_theme.dart'
c = open(f, 'r', encoding='utf-8').read()
c = c.replace('cardTheme: CardThemeData(', 'cardTheme: CardTheme(')
with open(f, 'w', encoding='utf-8') as file: file.write(c)

# Fix login_screen.dart Light variants
f = 'lib/features/authentication/screens/login_screen.dart'
c = open(f, 'r', encoding='utf-8').read()
c = c.replace('context.colors.textPrimaryLight', 'context.colors.textPrimary')
c = c.replace('context.colors.textSecondaryLight', 'context.colors.textSecondary')
with open(f, 'w', encoding='utf-8') as file: file.write(c)

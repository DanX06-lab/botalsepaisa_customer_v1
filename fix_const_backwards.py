import os, re, subprocess

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
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read().splitlines()
    
    for l in lines:
        idx = l - 1
        # scan backwards to find const
        for i in range(idx, max(-1, idx - 10), -1):
            if i < len(content):
                if 'const ' in content[i]:
                    content[i] = re.sub(r'\bconst\b\s*', '', content[i])
                    break
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write('\n'.join(content) + '\n')
print('Fixed constants by scanning backwards')

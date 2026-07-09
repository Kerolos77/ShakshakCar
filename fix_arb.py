import re

with open('lib/l10n/intl_ar.arb', encoding='utf-8') as f:
    content = f.read()

# Find the position of the first opening brace
first_brace = content.index('{')
# Find the last closing brace
last_brace = content.rindex('}')

# Extract all text between braces and parse key-value pairs
inner = content[first_brace+1:last_brace]

# Extract all key-value pairs (handles escaped quotes inside values)
pattern = r'"([^"]+)"\s*:\s*"((?:[^"\\]|\\.)*)"'
pairs = re.findall(pattern, inner)

# Build ordered dict to deduplicate (first occurrence wins to preserve original values)
seen = {}
order = []
for k, v in pairs:
    if k not in seen:
        order.append(k)
        seen[k] = v

# Build clean JSON
lines = ['{']
for i, k in enumerate(order):
    comma = ',' if i < len(order)-1 else ''
    escaped_v = seen[k]
    lines.append('  "' + k + '": "' + escaped_v + '"' + comma)
lines.append('}')
lines.append('')

result = '\r\n'.join(lines)
with open('lib/l10n/intl_ar.arb', 'w', encoding='utf-8') as f:
    f.write(result)

print('Done - ' + str(len(order)) + ' unique keys')

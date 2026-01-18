import { tokens } from './tokens';

/**
 * Generate CSS custom properties from tokens
 * For use in 11ty marketing site
 */
export function generateCSS(): string {
  const lines: string[] = [':root {'];

  // Colors
  Object.entries(tokens.colors).forEach(([category, values]) => {
    if (typeof values === 'object' && values !== null) {
      Object.entries(values).forEach(([key, value]) => {
        lines.push(`  --color-${category}-${key}: ${value};`);
      });
    }
  });

  // Spacing
  Object.entries(tokens.spacing).forEach(([key, value]) => {
    lines.push(`  --spacing-${key}: ${value}px;`);
  });

  // Typography
  lines.push(`  --font-family: ${tokens.typography.fontFamily};`);
  Object.entries(tokens.typography.fontSize).forEach(([key, value]) => {
    lines.push(`  --font-size-${key}: ${value}px;`);
  });
  Object.entries(tokens.typography.fontWeight).forEach(([key, value]) => {
    lines.push(`  --font-weight-${key}: ${value};`);
  });
  Object.entries(tokens.typography.lineHeight).forEach(([key, value]) => {
    lines.push(`  --line-height-${key}: ${value};`);
  });

  // Border radius
  Object.entries(tokens.borderRadius).forEach(([key, value]) => {
    lines.push(`  --border-radius-${key}: ${value}px;`);
  });

  lines.push('}');
  return lines.join('\n');
}

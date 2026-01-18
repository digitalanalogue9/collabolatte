/**
 * Design tokens for Collabolatte
 * Minimal set shared between web app and marketing site
 */

export const tokens = {
  colors: {
    primary: {
      main: '#3a7f6c',
      light: '#5d9a89',
      dark: '#2d6355',
      muted: '#6a9486',
      focus: '#7ea99a',
      contrastText: '#ffffff',
    },
    secondary: {
      main: '#6a9486',
      light: '#7ea99a',
      dark: '#5d9a89',
      contrastText: '#ffffff',
    },
    error: {
      main: '#F44336',
      light: '#ef5350',
      dark: '#c62828',
      contrastText: '#ffffff',
    },
    warning: {
      main: '#FF9800',
      light: '#ffb74d',
      dark: '#e65100',
      contrastText: '#ffffff',
    },
    info: {
      main: '#2196F3',
      light: '#64b5f6',
      dark: '#1976d2',
      contrastText: '#ffffff',
    },
    success: {
      main: '#4CAF50',
      light: '#81c784',
      dark: '#388e3c',
      contrastText: '#ffffff',
    },
    grey: {
      50: '#f6f5f2',
      100: '#f0ede7',
      200: '#e6e4df',
      300: '#d6d4cf',
      400: '#bdbdbd',
      500: '#9e9e9e',
      600: '#757575',
      700: '#4f5b61',
      800: '#1f2428',
      900: '#1a1d20',
    },
    background: {
      default: '#f6f5f2',
      paper: '#ffffff',
      muted: '#f0ede7',
    },
    text: {
      primary: '#1f2428',
      secondary: '#4f5b61',
      disabled: '#9e9e9e',
    },
    border: '#e6e4df',
    chip: '#f5f2ed',
  },
  spacing: {
    unit: 8,
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 48,
  },
  typography: {
    fontFamily:
      '"-apple-system", "BlinkMacSystemFont", "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", sans-serif',
    fontSize: {
      xs: 11,
      sm: 12,
      base: 14,
      md: 14,
      lg: 16,
      xl: 18,
      xxl: 24,
    },
    fontWeight: {
      light: 300,
      regular: 400,
      medium: 500,
      semibold: 600,
      bold: 700,
    },
    lineHeight: {
      tight: 1.2,
      normal: 1.6,
      relaxed: 1.75,
    },
  },
  borderRadius: {
    none: 0,
    sm: 4,
    md: 8,
    lg: 10,
    xl: 12,
    card: 14,
    full: 999,
  },
  shadows: {
    sm: '0 1px 2px 0 rgba(0, 0, 0, 0.04)',
    md: '0 2px 4px 0 rgba(0, 0, 0, 0.06)',
    lg: '0 4px 8px 0 rgba(0, 0, 0, 0.08)',
    xl: '0 8px 16px 0 rgba(0, 0, 0, 0.1)',
  },
  breakpoints: {
    xs: 0,
    sm: 600,
    md: 900,
    lg: 1200,
    xl: 1536,
  },
} as const;

export type Tokens = typeof tokens;

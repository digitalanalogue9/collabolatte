import { createTheme } from '@mui/material/styles';
import { tokens } from './tokens';

/**
 * Collabolatte MUI Theme - Sage Calm Design System
 *
 * Built from shared design tokens to ensure consistency
 * with the marketing site and other surfaces.
 *
 * Design principle: Calm, low-attention, trust-first aesthetic.
 */
export const muiTheme = createTheme({
  palette: {
    primary: {
      main: tokens.colors.primary.main,
      light: tokens.colors.primary.light,
      dark: tokens.colors.primary.dark,
      contrastText: tokens.colors.primary.contrastText,
    },
    secondary: {
      main: tokens.colors.secondary.main,
      light: tokens.colors.secondary.light,
      dark: tokens.colors.secondary.dark,
      contrastText: tokens.colors.secondary.contrastText,
    },
    error: {
      main: tokens.colors.error.main,
      light: tokens.colors.error.light,
      dark: tokens.colors.error.dark,
      contrastText: tokens.colors.error.contrastText,
    },
    warning: {
      main: tokens.colors.warning.main,
      light: tokens.colors.warning.light,
      dark: tokens.colors.warning.dark,
      contrastText: tokens.colors.warning.contrastText,
    },
    info: {
      main: tokens.colors.info.main,
      light: tokens.colors.info.light,
      dark: tokens.colors.info.dark,
      contrastText: tokens.colors.info.contrastText,
    },
    success: {
      main: tokens.colors.success.main,
      light: tokens.colors.success.light,
      dark: tokens.colors.success.dark,
      contrastText: tokens.colors.success.contrastText,
    },
    grey: tokens.colors.grey,
    background: {
      default: tokens.colors.background.default,
      paper: tokens.colors.background.paper,
    },
    text: tokens.colors.text,
    divider: tokens.colors.border,
  },
  spacing: tokens.spacing.unit,
  typography: {
    fontFamily: tokens.typography.fontFamily,
    fontSize: tokens.typography.fontSize.base,
    fontWeightLight: tokens.typography.fontWeight.light,
    fontWeightRegular: tokens.typography.fontWeight.regular,
    fontWeightMedium: tokens.typography.fontWeight.medium,
    fontWeightBold: tokens.typography.fontWeight.bold,
    h1: {
      fontSize: tokens.typography.fontSize.xl,
      fontWeight: tokens.typography.fontWeight.semibold,
      lineHeight: tokens.typography.lineHeight.tight,
    },
    h2: {
      fontSize: tokens.typography.fontSize.lg,
      fontWeight: tokens.typography.fontWeight.semibold,
      lineHeight: tokens.typography.lineHeight.normal,
    },
    h3: {
      fontSize: tokens.typography.fontSize.md,
      fontWeight: tokens.typography.fontWeight.semibold,
      lineHeight: tokens.typography.lineHeight.normal,
    },
    h4: {
      fontSize: tokens.typography.fontSize.md,
      fontWeight: tokens.typography.fontWeight.medium,
      lineHeight: tokens.typography.lineHeight.normal,
    },
    body1: {
      fontSize: tokens.typography.fontSize.base,
      lineHeight: tokens.typography.lineHeight.normal,
    },
    body2: {
      fontSize: tokens.typography.fontSize.sm,
      lineHeight: tokens.typography.lineHeight.normal,
    },
    button: {
      textTransform: 'none',
      fontWeight: tokens.typography.fontWeight.semibold,
      fontSize: tokens.typography.fontSize.sm,
    },
  },
  shape: {
    borderRadius: tokens.borderRadius.md,
  },
  breakpoints: {
    values: tokens.breakpoints,
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: tokens.borderRadius.md,
          padding: '8px 12px',
          minHeight: 34,
        },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          borderRadius: tokens.borderRadius.card,
          boxShadow: tokens.shadows.sm,
          border: `1px solid ${tokens.colors.border}`,
        },
      },
    },
    MuiChip: {
      styleOverrides: {
        root: {
          borderRadius: tokens.borderRadius.full,
          backgroundColor: tokens.colors.chip,
          border: `1px solid ${tokens.colors.border}`,
          fontSize: tokens.typography.fontSize.sm,
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: {
          backgroundImage: 'none',
        },
      },
    },
  },
});

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
    primary: tokens.colors.primary,
    secondary: tokens.colors.secondary,
    error: tokens.colors.error,
    warning: tokens.colors.warning,
    info: tokens.colors.info,
    success: tokens.colors.success,
    grey: tokens.colors.grey,
    background: tokens.colors.background,
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

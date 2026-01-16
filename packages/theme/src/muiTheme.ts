import { createTheme } from '@mui/material/styles';
import { tokens } from './tokens';

/**
 * MUI theme configuration for React web app
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
  },
  spacing: tokens.spacing.unit,
  typography: {
    fontFamily: tokens.typography.fontFamily,
    fontSize: tokens.typography.fontSize.md,
    fontWeightLight: tokens.typography.fontWeight.light,
    fontWeightRegular: tokens.typography.fontWeight.regular,
    fontWeightMedium: tokens.typography.fontWeight.medium,
    fontWeightBold: tokens.typography.fontWeight.bold,
  },
  shape: {
    borderRadius: tokens.borderRadius.md,
  },
  breakpoints: {
    values: tokens.breakpoints,
  },
});

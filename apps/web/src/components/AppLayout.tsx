import { Box, Container } from '@mui/material';
import { ReactNode } from 'react';

export interface AppLayoutProps {
  /** Main content to display */
  children: ReactNode;
  /** Optional header component */
  header?: ReactNode;
  /** Optional footer component */
  footer?: ReactNode;
  /** Maximum width constraint (default: 'md' for focused content) */
  maxWidth?: 'sm' | 'md' | 'lg' | 'xl' | false;
}

/**
 * AppLayout - Primary layout wrapper for the application
 *
 * Implements Sage Calm design principles:
 * - Generous whitespace (airy, low-density)
 * - Centered content for focus
 * - 8px base spacing rhythm
 * - Minimal depth/layering
 */
export const AppLayout = ({ children, header, footer, maxWidth = 'md' }: AppLayoutProps) => {
  return (
    <Box
      sx={{
        display: 'flex',
        flexDirection: 'column',
        minHeight: '100vh',
        bgcolor: 'background.default',
      }}
    >
      {header && (
        <Box
          component="header"
          sx={{
            py: 3,
            px: 2,
            borderBottom: 1,
            borderColor: 'divider',
          }}
        >
          <Container maxWidth={maxWidth}>{header}</Container>
        </Box>
      )}

      <Box
        component="main"
        sx={{
          flexGrow: 1,
          py: 6,
          px: 2,
        }}
      >
        <Container maxWidth={maxWidth}>{children}</Container>
      </Box>

      {footer && (
        <Box
          component="footer"
          sx={{
            py: 4,
            px: 2,
            borderTop: 1,
            borderColor: 'divider',
            mt: 'auto',
          }}
        >
          <Container maxWidth={maxWidth}>{footer}</Container>
        </Box>
      )}
    </Box>
  );
};

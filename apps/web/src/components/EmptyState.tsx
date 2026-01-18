import { Box, Typography, Button } from '@mui/material';
import { ReactNode } from 'react';

export interface EmptyStateProps {
  /** Icon or illustration to display (optional) */
  icon?: ReactNode;
  /** Main message */
  message: string;
  /** Supporting description (optional) */
  description?: string;
  /** Optional action button label */
  actionLabel?: string;
  /** Callback when action button is clicked */
  onAction?: () => void;
}

/**
 * EmptyState - Calm, reassuring empty state component
 *
 * Implements:
 * - Calm, non-alarming messaging
 * - Minimal visual treatment
 * - Optional guidance action
 * - Low-pressure tone
 *
 * Used when there are no matches, no programmes, or waiting states.
 */
export const EmptyState = ({
  icon,
  message,
  description,
  actionLabel,
  onAction,
}: EmptyStateProps) => {
  return (
    <Box
      sx={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        textAlign: 'center',
        py: 8,
        px: 3,
      }}
    >
      {icon && (
        <Box
          sx={{
            mb: 3,
            color: 'text.secondary',
            opacity: 0.5,
            fontSize: '3rem',
          }}
        >
          {icon}
        </Box>
      )}

      <Typography
        variant="h2"
        color="text.secondary"
        gutterBottom
        sx={{
          fontSize: '1.125rem',
          fontWeight: 500,
        }}
      >
        {message}
      </Typography>

      {description && (
        <Typography
          variant="body1"
          color="text.secondary"
          sx={{
            maxWidth: 400,
            mt: 1,
            opacity: 0.8,
          }}
        >
          {description}
        </Typography>
      )}

      {actionLabel && onAction && (
        <Button
          variant="outlined"
          onClick={onAction}
          sx={{
            mt: 3,
          }}
        >
          {actionLabel}
        </Button>
      )}
    </Box>
  );
};

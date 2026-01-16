import { Box, Typography, Collapse, IconButton } from '@mui/material';
import { ExpandMore as ExpandMoreIcon } from '@mui/icons-material';
import { useState } from 'react';

export interface ContextInfoBlockProps {
  /** Title for the info block */
  title?: string;
  /** Content to display */
  children: React.ReactNode;
  /** Whether the block starts expanded */
  defaultExpanded?: boolean;
  /** Whether the block is collapsible */
  collapsible?: boolean;
}

/**
 * ContextInfoBlock - Direction 2: Quiet Context
 *
 * Implements:
 * - Subdued, secondary styling
 * - Answers "what happens next" without competing
 * - Optional collapsible behavior
 * - Low-attention, calm presentation
 *
 * Used for contextual information that reduces anxiety without adding goals.
 */
export const ContextInfoBlock = ({
  title = 'What happens next',
  children,
  defaultExpanded = true,
  collapsible = true,
}: ContextInfoBlockProps) => {
  const [expanded, setExpanded] = useState(defaultExpanded);

  const handleToggle = () => {
    if (collapsible) {
      setExpanded(!expanded);
    }
  };

  return (
    <Box
      sx={{
        bgcolor: 'grey.50',
        border: 1,
        borderColor: 'divider',
        borderRadius: 1,
        p: 2,
        mt: 3,
      }}
    >
      <Box
        sx={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          cursor: collapsible ? 'pointer' : 'default',
        }}
        onClick={handleToggle}
      >
        <Typography
          variant="body2"
          color="text.secondary"
          sx={{
            fontWeight: 500,
            fontSize: '0.875rem',
          }}
        >
          {title}
        </Typography>

        {collapsible && (
          <IconButton
            size="small"
            sx={{
              transform: expanded ? 'rotate(180deg)' : 'rotate(0deg)',
              transition: 'transform 0.2s',
            }}
            aria-expanded={expanded}
            aria-label="toggle context information"
          >
            <ExpandMoreIcon fontSize="small" />
          </IconButton>
        )}
      </Box>

      <Collapse in={expanded}>
        <Box sx={{ mt: 1 }}>
          <Typography variant="body2" color="text.secondary">
            {children}
          </Typography>
        </Box>
      </Collapse>
    </Box>
  );
};

import { Card, CardContent, CardActions, Button, Typography, Box } from '@mui/material';

export interface ProgrammeStatusCardProps {
  /** Programme name */
  programmeName: string;
  /** Programme description */
  description: string;
  /** Next match date/period */
  nextMatch?: string;
  /** Current participation status */
  status: 'active' | 'paused' | 'not-joined';
  /** Callback when primary action is clicked */
  onPrimaryAction?: () => void;
  /** Callback when secondary action is clicked */
  onSecondaryAction?: () => void;
}

/**
 * ProgrammeStatusCard - Direction 3: MVP Programme Card
 *
 * Implements:
 * - Programme overview and status
 * - Minimal, calm presentation
 * - Trust language ("optional", "no tracking")
 * - Clear participation status
 *
 * Secondary view for programme management; match card is primary experience.
 */
export const ProgrammeStatusCard = ({
  programmeName,
  description,
  nextMatch,
  status,
  onPrimaryAction,
  onSecondaryAction,
}: ProgrammeStatusCardProps) => {
  const getPrimaryLabel = () => {
    switch (status) {
      case 'not-joined':
        return 'Join';
      case 'paused':
        return 'Resume';
      case 'active':
        return 'Settings';
    }
  };

  const getSecondaryLabel = () => {
    switch (status) {
      case 'not-joined':
        return 'Learn more';
      case 'paused':
        return 'Leave';
      case 'active':
        return 'Pause';
    }
  };

  return (
    <Card>
      <CardContent>
        <Typography variant="h2" gutterBottom>
          {programmeName}
        </Typography>

        <Typography variant="body1" color="text.secondary" paragraph>
          {description}
        </Typography>

        {nextMatch && status === 'active' && (
          <Box
            sx={{
              mt: 3,
              pt: 2,
              borderTop: 1,
              borderColor: 'divider',
            }}
          >
            <Typography
              variant="body2"
              color="text.secondary"
              sx={{ fontSize: '0.75rem', textTransform: 'uppercase', letterSpacing: '0.05em' }}
            >
              Next match
            </Typography>
            <Typography variant="body1" sx={{ mt: 0.5 }}>
              {nextMatch}
            </Typography>
          </Box>
        )}

        {status === 'paused' && (
          <Box
            sx={{
              mt: 2,
              p: 1.5,
              bgcolor: 'grey.50',
              borderRadius: 1,
            }}
          >
            <Typography variant="body2" color="text.secondary">
              You're paused. You won't receive matches until you resume.
            </Typography>
          </Box>
        )}
      </CardContent>

      <CardActions sx={{ px: 2, pb: 2, gap: 1 }}>
        <Button variant="contained" onClick={onPrimaryAction} fullWidth>
          {getPrimaryLabel()}
        </Button>
        <Button variant="outlined" onClick={onSecondaryAction} fullWidth>
          {getSecondaryLabel()}
        </Button>
      </CardActions>
    </Card>
  );
};

import { Card, CardContent, CardActions, Button, Typography, Box, Chip } from '@mui/material';

export interface JoinCardProps {
  /** Programme name (optional) */
  programmeName?: string;
  /** Callback when Join is clicked */
  onJoin?: () => void;
  /** Callback when Not Now is clicked */
  onNotNow?: () => void;
}

/**
 * JoinCard - First-time entry screen (Direction 6: Minimal Join-First)
 *
 * Implements:
 * - Minimal, calm entry experience
 * - Trust language ("optional", "no tracking", "easy to skip")
 * - Clear escape hatch ("Not now")
 * - Low-pressure invitation
 *
 * Shown only on first visit; users who join see match screen immediately.
 */
export const JoinCard = ({ programmeName, onJoin, onNotNow }: JoinCardProps) => {
  return (
    <Card sx={{ maxWidth: 480, mx: 'auto' }}>
      <CardContent>
        <Typography variant="h2" gutterBottom>
          Join {programmeName || 'Collabolatte'}
        </Typography>

        <Typography variant="body1" color="text.secondary" paragraph>
          One programme, monthly matches, optional participation. You can leave anytime.
        </Typography>

        <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', mt: 3 }}>
          <Chip label="No tracking" size="small" />
          <Chip label="No obligation" size="small" />
          <Chip label="Easy to skip" size="small" />
        </Box>
      </CardContent>

      <CardActions sx={{ px: 2, pb: 2, gap: 1 }}>
        <Button variant="contained" onClick={onJoin} fullWidth>
          Join
        </Button>
        <Button variant="outlined" onClick={onNotNow} fullWidth>
          Not now
        </Button>
      </CardActions>
    </Card>
  );
};

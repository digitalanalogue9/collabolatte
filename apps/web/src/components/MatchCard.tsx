import { Card, CardContent, CardActions, Button, Chip, Box, Typography } from '@mui/material';

export interface MatchCardProps {
  matchedName: string;
  nextMatchDate?: string;
  onIntroduce?: () => void;
  onSkip?: () => void;
}

/**
 * Match notification card - core MVP UI component
 * Shows user they've been matched and allows them to introduce or skip
 */
export const MatchCard = ({ matchedName, nextMatchDate, onIntroduce, onSkip }: MatchCardProps) => {
  return (
    <Card>
      <CardContent>
        <Box sx={{ display: 'flex', gap: 1, mb: 2, flexWrap: 'wrap' }}>
          <Chip label="Optional" size="small" />
          <Chip label="No tracking" size="small" />
        </Box>

        <Typography variant="h2" gutterBottom>
          You've been matched with {matchedName}
        </Typography>

        <Typography variant="body1" color="text.secondary">
          If you'd like, say hello and propose a short coffee chat. Skipping is fine.
        </Typography>

        {nextMatchDate && (
          <Box sx={{ mt: 2, p: 2, bgcolor: 'background.default', borderRadius: 2 }}>
            <Typography variant="caption" color="text.secondary">
              Next match
            </Typography>
            <Typography variant="body1">{nextMatchDate}</Typography>
          </Box>
        )}
      </CardContent>

      <CardActions sx={{ p: 2, pt: 0 }}>
        <Button variant="contained" onClick={onIntroduce}>
          Introduce yourself
        </Button>
        <Button variant="outlined" onClick={onSkip}>
          Skip
        </Button>
      </CardActions>
    </Card>
  );
};

import { Typography } from '@mui/material';

export interface LogoProps {
  /** Size variant */
  size?: 'small' | 'medium' | 'large';
  /** Optional onClick handler for making logo clickable */
  onClick?: () => void;
}

/**
 * Brand logo component - text-based, minimal, calm
 * Uses Sage Calm aesthetic with understated presentation
 */
export const Logo = ({ size = 'medium', onClick }: LogoProps) => {
  const fontSize = {
    small: '1.25rem',
    medium: '1.5rem',
    large: '2rem',
  }[size];

  return (
    <Typography
      variant="h1"
      sx={{
        fontSize,
        fontWeight: 500,
        color: 'primary.main',
        cursor: onClick ? 'pointer' : 'default',
        userSelect: 'none',
        '&:hover': onClick
          ? {
              opacity: 0.8,
            }
          : {},
      }}
      onClick={onClick}
    >
      Collabolatte
    </Typography>
  );
};

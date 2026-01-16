import { Box, Link, Typography } from '@mui/material';

export interface AppFooterProps {
  /** Optional additional links */
  additionalLinks?: { label: string; href: string }[];
}

/**
 * AppFooter - Simple footer with essential links
 *
 * Features:
 * - Privacy, Terms, Support links
 * - Low-attention, secondary styling
 * - Optional additional links
 *
 * Follows Sage Calm principles: minimal, understated, calm
 */
export const AppFooter = ({ additionalLinks }: AppFooterProps) => {
  const defaultLinks = [
    { label: 'Privacy', href: '/privacy' },
    { label: 'Terms', href: '/terms' },
    { label: 'Support', href: '/support' },
  ];

  const allLinks = [...defaultLinks, ...(additionalLinks || [])];

  return (
    <Box
      sx={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        gap: 2,
      }}
    >
      <Box
        sx={{
          display: 'flex',
          gap: 3,
          flexWrap: 'wrap',
          justifyContent: 'center',
        }}
      >
        {allLinks.map((link) => (
          <Link
            key={link.label}
            href={link.href}
            underline="hover"
            color="text.secondary"
            sx={{
              fontSize: '0.875rem',
            }}
          >
            {link.label}
          </Link>
        ))}
      </Box>

      <Typography
        variant="body2"
        color="text.secondary"
        sx={{
          fontSize: '0.75rem',
          opacity: 0.7,
        }}
      >
        © {new Date().getFullYear()} Collabolatte
      </Typography>
    </Box>
  );
};

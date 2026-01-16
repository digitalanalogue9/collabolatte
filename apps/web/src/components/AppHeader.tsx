import { Box, IconButton, Menu, MenuItem, Avatar } from '@mui/material';
import { Settings as SettingsIcon } from '@mui/icons-material';
import { useState, MouseEvent } from 'react';
import { Logo } from './Logo';

export interface AppHeaderProps {
  /** User's display name */
  userName?: string;
  /** User's avatar URL (optional) */
  avatarUrl?: string;
  /** Callback when logo is clicked */
  onLogoClick?: () => void;
  /** Callback when settings is clicked */
  onSettingsClick?: () => void;
  /** Callback when opt-out is clicked */
  onOptOutClick?: () => void;
}

/**
 * AppHeader - Minimal application header
 *
 * Features:
 * - Brand logo (clickable for navigation)
 * - User name/avatar display
 * - Settings menu (opt-out access)
 *
 * Follows Sage Calm principles: understated, low-attention, calm
 */
export const AppHeader = ({
  userName,
  avatarUrl,
  onLogoClick,
  onSettingsClick,
  onOptOutClick,
}: AppHeaderProps) => {
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const menuOpen = Boolean(anchorEl);

  const handleMenuOpen = (event: MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
  };

  const handleSettingsClick = () => {
    handleMenuClose();
    onSettingsClick?.();
  };

  const handleOptOutClick = () => {
    handleMenuClose();
    onOptOutClick?.();
  };

  const initials = userName
    ?.split(' ')
    .map((n) => n[0])
    .join('')
    .toUpperCase()
    .slice(0, 2);

  return (
    <Box
      sx={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
      }}
    >
      <Logo size="small" onClick={onLogoClick} />

      <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
        {userName && (
          <Avatar
            src={avatarUrl}
            alt={userName}
            sx={{
              width: 32,
              height: 32,
              bgcolor: 'primary.main',
              fontSize: '0.875rem',
            }}
          >
            {!avatarUrl && initials}
          </Avatar>
        )}

        <IconButton
          onClick={handleMenuOpen}
          size="small"
          aria-label="Settings"
          aria-controls={menuOpen ? 'settings-menu' : undefined}
          aria-haspopup="true"
          aria-expanded={menuOpen ? 'true' : undefined}
        >
          <SettingsIcon />
        </IconButton>

        <Menu
          id="settings-menu"
          anchorEl={anchorEl}
          open={menuOpen}
          onClose={handleMenuClose}
          MenuListProps={{
            'aria-labelledby': 'settings-button',
          }}
        >
          <MenuItem onClick={handleSettingsClick}>Settings</MenuItem>
          <MenuItem onClick={handleOptOutClick}>Opt out</MenuItem>
        </Menu>
      </Box>
    </Box>
  );
};

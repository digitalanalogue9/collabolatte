import type { Meta, StoryObj } from '@storybook/react';
import { fn } from '@storybook/test';
import { AppHeader } from './AppHeader';

/**
 * AppHeader provides minimal navigation and user context.
 * Displays brand logo, user identity, and access to settings/opt-out.
 */
const meta = {
  title: 'Layout/AppHeader',
  component: AppHeader,
  parameters: {
    layout: 'padded',
  },
  tags: ['autodocs'],
  argTypes: {
    userName: {
      control: 'text',
      description: 'User display name',
    },
    avatarUrl: {
      control: 'text',
      description: 'User avatar image URL',
    },
  },
  args: {
    onLogoClick: fn(),
    onSettingsClick: fn(),
    onOptOutClick: fn(),
  },
} satisfies Meta<typeof AppHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

/**
 * Default header with user name (initials avatar)
 */
export const Default: Story = {
  args: {
    userName: 'Samira Johnson',
  },
};

/**
 * Header with user avatar image
 */
export const WithAvatar: Story = {
  args: {
    userName: 'Tomás García',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
  },
};

/**
 * Header without user (anonymous/logged out state)
 */
export const Anonymous: Story = {
  args: {},
};

/**
 * Header with single-name user
 */
export const SingleName: Story = {
  args: {
    userName: 'Alexandra',
  },
};

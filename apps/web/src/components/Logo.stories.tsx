import type { Meta, StoryObj } from '@storybook/react';
import { fn } from '@storybook/test';
import { Logo } from './Logo';

/**
 * Logo is the text-based brand identifier used throughout the app.
 * Follows Sage Calm design principles: understated, minimal, calm.
 */
const meta = {
  title: 'Components/Logo',
  component: Logo,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    size: {
      control: 'select',
      options: ['small', 'medium', 'large'],
      description: 'Size variant for different contexts',
    },
  },
} satisfies Meta<typeof Logo>;

export default meta;
type Story = StoryObj<typeof meta>;

/**
 * Default logo at medium size
 */
export const Default: Story = {
  args: {
    size: 'medium',
  },
};

/**
 * Small logo for compact header layouts
 */
export const Small: Story = {
  args: {
    size: 'small',
  },
};

/**
 * Large logo for landing/splash screens
 */
export const Large: Story = {
  args: {
    size: 'large',
  },
};

/**
 * Clickable logo (e.g., navigating home)
 */
export const Clickable: Story = {
  args: {
    size: 'medium',
    onClick: fn(),
  },
};

import type { Meta, StoryObj } from '@storybook/react';
import { fn } from '@storybook/test';
import { MatchCard } from './MatchCard';

/**
 * MatchCard is the core UI component for MVP - shows a match notification
 * with optional actions. Demonstrates the Sage Calm design system.
 */
const meta = {
  title: 'Components/MatchCard',
  component: MatchCard,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    matchedName: {
      control: 'text',
      description: 'Name of the person matched with',
    },
    nextMatchDate: {
      control: 'text',
      description: 'Date of next match (optional)',
    },
  },
  args: {
    onIntroduce: fn(),
    onSkip: fn(),
  },
} satisfies Meta<typeof MatchCard>;

export default meta;
type Story = StoryObj<typeof meta>;

/**
 * Default match card with next match date
 */
export const Default: Story = {
  args: {
    matchedName: 'Samira',
    nextMatchDate: 'Week of 12 May',
  },
};

/**
 * Match card without next match date
 */
export const WithoutNextMatch: Story = {
  args: {
    matchedName: 'Tomás',
  },
};

/**
 * Match card with longer name
 */
export const LongName: Story = {
  args: {
    matchedName: 'Dr. Alexandra Smith-Johnson',
    nextMatchDate: 'Week of 12 May',
  },
};

import type { Meta, StoryObj } from '@storybook/react';
import { fn } from '@storybook/test';
import { EmptyState } from './EmptyState';
import { CalendarMonth as CalendarIcon } from '@mui/icons-material';

/**
 * EmptyState provides calm, reassuring messaging when there's no content.
 * Used for no matches, waiting periods, or empty programme lists.
 */
const meta = {
  title: 'Components/EmptyState',
  component: EmptyState,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    message: {
      control: 'text',
      description: 'Main empty state message',
    },
    description: {
      control: 'text',
      description: 'Supporting description (optional)',
    },
    actionLabel: {
      control: 'text',
      description: 'Action button label (optional)',
    },
  },
  args: {
    onAction: fn(),
  },
} satisfies Meta<typeof EmptyState>;

export default meta;
type Story = StoryObj<typeof meta>;

/**
 * No matches available (waiting for next match)
 */
export const NoMatches: Story = {
  args: {
    message: 'No matches right now',
    description: "You'll be matched again in the next cycle. Nothing to do until then.",
  },
  render: (args) => <EmptyState {...args} icon={<CalendarIcon />} />,
};

/**
 * No programmes joined yet
 */
export const NoProgrammes: Story = {
  args: {
    message: "You haven't joined any programmes yet",
    description: "When you join a programme, you'll see it here. Participation is always optional.",
    actionLabel: 'Browse programmes',
  },
};

/**
 * Waiting for programme to start
 */
export const WaitingToStart: Story = {
  args: {
    message: 'Waiting for the next cycle',
    description:
      "The next matching cycle starts in early June. You'll be notified when you have a match.",
  },
  render: (args) => <EmptyState {...args} icon={<CalendarIcon />} />,
};

/**
 * Minimal empty state (message only)
 */
export const Minimal: Story = {
  args: {
    message: 'Nothing to show here',
  },
};

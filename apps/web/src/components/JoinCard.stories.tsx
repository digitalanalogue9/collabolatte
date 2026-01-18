import type { Meta, StoryObj } from '@storybook/react';
import { fn } from '@storybook/test';
import { JoinCard } from './JoinCard';

/**
 * JoinCard is the first-time entry screen implementing Direction 6.
 * Shows minimal, low-pressure invitation with trust language.
 * Only shown once; users who join see match screen immediately.
 */
const meta = {
  title: 'Components/JoinCard',
  component: JoinCard,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    programmeName: {
      control: 'text',
      description: 'Programme name (optional, defaults to "Collabolatte")',
    },
  },
  args: {
    onJoin: fn(),
    onNotNow: fn(),
  },
} satisfies Meta<typeof JoinCard>;

export default meta;
type Story = StoryObj<typeof meta>;

/**
 * Default join card
 */
export const Default: Story = {
  args: {},
};

/**
 * Join card with custom programme name
 */
export const CustomProgramme: Story = {
  args: {
    programmeName: 'Engineering Connect',
  },
};

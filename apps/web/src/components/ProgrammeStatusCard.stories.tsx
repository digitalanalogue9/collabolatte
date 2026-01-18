import type { Meta, StoryObj } from '@storybook/react';
import { fn } from '@storybook/test';
import { ProgrammeStatusCard } from './ProgrammeStatusCard';

/**
 * ProgrammeStatusCard implements Direction 3: MVP Programme Card.
 * Shows programme overview and participation status.
 * Secondary view; match card is the primary experience.
 */
const meta = {
  title: 'Components/ProgrammeStatusCard',
  component: ProgrammeStatusCard,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    status: {
      control: 'select',
      options: ['active', 'paused', 'not-joined'],
      description: 'Current participation status',
    },
    programmeName: {
      control: 'text',
      description: 'Programme name',
    },
    description: {
      control: 'text',
      description: 'Programme description',
    },
    nextMatch: {
      control: 'text',
      description: 'Next match date/period (shown when active)',
    },
  },
  args: {
    onPrimaryAction: fn(),
    onSecondaryAction: fn(),
  },
} satisfies Meta<typeof ProgrammeStatusCard>;

export default meta;
type Story = StoryObj<typeof meta>;

/**
 * Active programme with upcoming match
 */
export const Active: Story = {
  args: {
    programmeName: 'Collabolatte',
    description: 'Casual cross-team coffees once a month. Optional. No tracking.',
    nextMatch: 'Week of 12 May',
    status: 'active',
  },
};

/**
 * Paused programme (user has paused participation)
 */
export const Paused: Story = {
  args: {
    programmeName: 'Engineering Connect',
    description: 'Monthly connections across engineering teams. Low-pressure, easy to skip.',
    status: 'paused',
  },
};

/**
 * Programme user hasn't joined yet
 */
export const NotJoined: Story = {
  args: {
    programmeName: 'Product Connects',
    description:
      'Meet product teammates from other squads. Quarterly matches, completely optional.',
    status: 'not-joined',
  },
};

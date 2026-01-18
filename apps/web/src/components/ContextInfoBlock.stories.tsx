import type { Meta, StoryObj } from '@storybook/react';
import { ContextInfoBlock } from './ContextInfoBlock';

/**
 * ContextInfoBlock implements Direction 2: Quiet Context.
 * Provides subdued secondary information that answers "what happens next"
 * without competing with the primary action.
 */
const meta = {
  title: 'Components/ContextInfoBlock',
  component: ContextInfoBlock,
  parameters: {
    layout: 'padded',
  },
  tags: ['autodocs'],
  argTypes: {
    title: {
      control: 'text',
      description: 'Title for the info block',
    },
    defaultExpanded: {
      control: 'boolean',
      description: 'Whether the block starts expanded',
    },
    collapsible: {
      control: 'boolean',
      description: 'Whether the block can be collapsed',
    },
  },
} satisfies Meta<typeof ContextInfoBlock>;

export default meta;
type Story = StoryObj<typeof meta>;

/**
 * Default collapsible context block
 */
export const Default: Story = {
  args: {
    title: 'What happens next',
    children:
      "Nothing required. You'll be matched again on the next cadence. No tracking, no obligation.",
    defaultExpanded: true,
    collapsible: true,
  },
};

/**
 * Context block that starts collapsed
 */
export const Collapsed: Story = {
  args: {
    title: 'How matching works',
    children:
      'We pair you randomly with someone from a different team each month. Participation is always optional.',
    defaultExpanded: false,
    collapsible: true,
  },
};

/**
 * Non-collapsible context block (always visible)
 */
export const AlwaysVisible: Story = {
  args: {
    title: 'Important information',
    children:
      "Your participation status is private. No one can see whether you've been matched or skipped.",
    collapsible: false,
  },
};

/**
 * Context block with custom title
 */
export const CustomTitle: Story = {
  args: {
    title: 'Why we do this',
    children:
      'Cross-team connections help break down silos and build a stronger culture. But it only works if it feels natural and low-pressure.',
    defaultExpanded: true,
    collapsible: true,
  },
};

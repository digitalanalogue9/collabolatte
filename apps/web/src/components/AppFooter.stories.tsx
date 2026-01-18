import type { Meta, StoryObj } from '@storybook/react';
import { AppFooter } from './AppFooter';

/**
 * AppFooter provides essential links and copyright information.
 * Designed to be low-attention and unobtrusive.
 */
const meta = {
  title: 'Layout/AppFooter',
  component: AppFooter,
  parameters: {
    layout: 'padded',
  },
  tags: ['autodocs'],
} satisfies Meta<typeof AppFooter>;

export default meta;
type Story = StoryObj<typeof meta>;

/**
 * Default footer with standard links
 */
export const Default: Story = {
  args: {},
};

/**
 * Footer with additional custom links
 */
export const WithAdditionalLinks: Story = {
  args: {
    additionalLinks: [
      { label: 'About', href: '/about' },
      { label: 'Contact', href: '/contact' },
    ],
  },
};

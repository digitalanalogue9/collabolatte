import type { Meta, StoryObj } from '@storybook/react';
import { AppLayout } from './AppLayout';
import { Logo } from './Logo';
import { Box, Typography, Link } from '@mui/material';

/**
 * AppLayout is the primary wrapper component for application pages.
 * Provides consistent structure with header, footer, and centered content.
 * Implements generous whitespace and airy layout principles.
 */
const meta = {
  title: 'Layout/AppLayout',
  component: AppLayout,
  parameters: {
    layout: 'fullscreen',
  },
  tags: ['autodocs'],
  argTypes: {
    maxWidth: {
      control: 'select',
      options: ['sm', 'md', 'lg', 'xl', false],
      description: 'Maximum width for content container',
    },
  },
} satisfies Meta<typeof AppLayout>;

export default meta;
type Story = StoryObj<typeof meta>;

// Sample header component
const SampleHeader = (
  <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
    <Logo size="small" />
    <Typography variant="body2" color="text.secondary">
      User Name
    </Typography>
  </Box>
);

// Sample footer component
const SampleFooter = (
  <Box sx={{ display: 'flex', gap: 3, justifyContent: 'center' }}>
    <Link href="#" underline="hover" color="text.secondary">
      Privacy
    </Link>
    <Link href="#" underline="hover" color="text.secondary">
      Terms
    </Link>
    <Link href="#" underline="hover" color="text.secondary">
      Support
    </Link>
  </Box>
);

// Sample content
const SampleContent = (
  <Box>
    <Typography variant="h2" gutterBottom>
      Page Title
    </Typography>
    <Typography variant="body1" color="text.secondary" paragraph>
      This is sample content demonstrating the layout's generous whitespace and centered
      presentation. The layout provides a calm, focused environment for the user.
    </Typography>
    <Typography variant="body1" color="text.secondary">
      Notice the airy spacing and low-density design that reduces cognitive load.
    </Typography>
  </Box>
);

/**
 * Complete layout with header, content, and footer
 */
export const Complete: Story = {
  args: {
    header: SampleHeader,
    children: SampleContent,
    footer: SampleFooter,
    maxWidth: 'md',
  },
};

/**
 * Content only (no header or footer)
 */
export const ContentOnly: Story = {
  args: {
    children: SampleContent,
    maxWidth: 'md',
  },
};

/**
 * With header, no footer
 */
export const WithHeader: Story = {
  args: {
    header: SampleHeader,
    children: SampleContent,
    maxWidth: 'md',
  },
};

/**
 * With footer, no header
 */
export const WithFooter: Story = {
  args: {
    children: SampleContent,
    footer: SampleFooter,
    maxWidth: 'md',
  },
};

/**
 * Narrow layout (small max width)
 */
export const Narrow: Story = {
  args: {
    header: SampleHeader,
    children: SampleContent,
    footer: SampleFooter,
    maxWidth: 'sm',
  },
};

/**
 * Wide layout (large max width)
 */
export const Wide: Story = {
  args: {
    header: SampleHeader,
    children: SampleContent,
    footer: SampleFooter,
    maxWidth: 'lg',
  },
};

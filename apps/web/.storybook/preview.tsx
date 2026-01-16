import type { Preview } from '@storybook/react';
import { ThemeProvider } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';
import { muiTheme } from '../../../packages/theme/src/muiTheme';
import React from 'react';

const preview: Preview = {
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
    backgrounds: {
      default: 'collabolatte',
      values: [
        {
          name: 'collabolatte',
          value: '#f6f5f2',
        },
        {
          name: 'white',
          value: '#ffffff',
        },
      ],
    },
  },
  decorators: [
    (Story) => (
      <ThemeProvider theme={muiTheme}>
        <CssBaseline />
        <Story />
      </ThemeProvider>
    ),
  ],
};

export default preview;

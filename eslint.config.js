import { defineConfig, globalIgnores } from 'eslint/config'

import webConfig from './apps/web/eslint.config.js'

export default defineConfig([
  globalIgnores(['dist', 'node_modules', '**/bin', '**/obj']),
  ...webConfig,
])

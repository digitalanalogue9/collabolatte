import js from '@eslint/js'
import globals from 'globals'
import jsdoc from 'eslint-plugin-jsdoc'
import reactHooks from 'eslint-plugin-react-hooks'
import reactRefresh from 'eslint-plugin-react-refresh'
import tseslint from 'typescript-eslint'
import { defineConfig, globalIgnores } from 'eslint/config'

export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      js.configs.recommended,
      tseslint.configs.recommended,
      reactHooks.configs.flat.recommended,
      reactRefresh.configs.vite,
    ],
    plugins: {
      jsdoc,
    },
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
    },
    rules: {
      'jsdoc/require-jsdoc': [
        'error',
        {
          contexts: [
            'ExportNamedDeclaration[declaration.type="FunctionDeclaration"]',
            'ExportNamedDeclaration[declaration.type="ClassDeclaration"]',
            'ExportNamedDeclaration[declaration.type="VariableDeclaration"][declaration.declarations.0.init.type="ArrowFunctionExpression"]',
            'ExportDefaultDeclaration[declaration.type="FunctionDeclaration"]',
            'ExportDefaultDeclaration[declaration.type="ClassDeclaration"]',
            'ExportDefaultDeclaration[declaration.type="ArrowFunctionExpression"]',
          ],
        },
      ],
      'jsdoc/require-description': 'error',
    },
  },
])

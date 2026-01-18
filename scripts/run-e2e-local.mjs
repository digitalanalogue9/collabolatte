import { spawn } from 'node:child_process';
import net from 'node:net';

const pnpm = process.platform === 'win32' ? 'pnpm.cmd' : 'pnpm';
const spawnOptions = { stdio: 'inherit', shell: process.platform === 'win32' };

const webUrl = process.env.PLAYWRIGHT_WEB_BASE_URL ?? 'http://localhost:3000';
const marketingUrl =
  process.env.PLAYWRIGHT_MARKETING_BASE_URL ?? 'http://localhost:8080';
const webPort = Number(new URL(webUrl).port || '3000');
const marketingPort = Number(new URL(marketingUrl).port || '8080');

const timeoutMs = 60_000;
const pollIntervalMs = 1_000;

const runCommand = (label, args) =>
  new Promise((resolve, reject) => {
    console.log(label);
    const child = spawn(pnpm, args, spawnOptions);
    child.on('exit', (code) => {
      if (code === 0) resolve(undefined);
      else reject(new Error(`${label} failed with exit code ${code ?? 1}`));
    });
  });

const isPortInUse = (port) =>
  new Promise((resolve) => {
    const socket = net.connect(port, '127.0.0.1');
    socket.once('connect', () => {
      socket.destroy();
      resolve(true);
    });
    socket.once('error', () => resolve(false));
  });

if (await isPortInUse(webPort)) {
  console.error(
    `Port ${webPort} is already in use. Set PLAYWRIGHT_WEB_BASE_URL to a free port.`,
  );
  process.exit(1);
}

if (await isPortInUse(marketingPort)) {
  console.error(
    `Port ${marketingPort} is already in use. Set PLAYWRIGHT_MARKETING_BASE_URL to a free port.`,
  );
  process.exit(1);
}

await runCommand('Building web app...', ['--filter', '@collabolatte/web', 'build']);
await runCommand('Building marketing site...', [
  '--filter',
  '@collabolatte/marketing',
  'build',
]);

console.log('Starting preview servers...');

const web = spawn(
  pnpm,
  ['--filter', '@collabolatte/web', 'preview', '--port', String(webPort), '--strictPort'],
  spawnOptions,
);

const marketing = spawn(
  pnpm,
  [
    '--filter',
    '@collabolatte/marketing',
    'preview',
    '--port',
    String(marketingPort),
  ],
  spawnOptions,
);

const killAll = () => {
  if (!web.killed) web.kill();
  if (!marketing.killed) marketing.kill();
};

process.on('SIGINT', () => {
  killAll();
  process.exit(130);
});

process.on('SIGTERM', () => {
  killAll();
  process.exit(143);
});

async function waitForUrl(url, label) {
  const deadline = Date.now() + timeoutMs;
  const startedAt = Date.now();
  console.log(`Waiting for ${label} at ${url}...`);
  while (Date.now() < deadline) {
    try {
      const res = await fetch(url, { method: 'GET' });
      if (res.ok) {
        const elapsed = Math.round((Date.now() - startedAt) / 1000);
        console.log(`${label} is ready (${elapsed}s).`);
        return;
      }
    } catch {
      // ignore and retry
    }
    await new Promise((resolve) => setTimeout(resolve, pollIntervalMs));
  }
  throw new Error(`Timed out waiting for ${label} at ${url}`);
}

try {
  await Promise.all([
    waitForUrl(webUrl, 'web preview'),
    waitForUrl(marketingUrl, 'marketing preview'),
  ]);

  console.log('Running Playwright tests...');
  const tests = spawn(
    pnpm,
    ['exec', 'playwright', 'test', '--config', 'tests/playwright.config.ts'],
    spawnOptions,
  );

  tests.on('exit', (code) => {
    killAll();
    process.exit(code ?? 1);
  });
} catch (error) {
  console.error(error instanceof Error ? error.message : error);
  killAll();
  process.exit(1);
}

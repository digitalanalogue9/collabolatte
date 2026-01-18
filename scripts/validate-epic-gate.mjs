import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';
import { parse as parseYaml } from 'yaml';

const scriptFilePath = fileURLToPath(import.meta.url);
const repoRoot = path.resolve(path.dirname(scriptFilePath), '..');

function parseArgs(argv) {
  const args = { targetEpic: undefined };
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === '--target' || arg === '--target-epic') {
      args.targetEpic = argv[i + 1];
      i += 1;
    } else if (arg.startsWith('--target=')) {
      args.targetEpic = arg.split('=')[1];
    }
  }
  return args;
}

function isEpicKey(key) {
  return /^epic-\d+$/.test(key);
}

function isRetrospectiveKey(key) {
  return /^epic-\d+-retrospective$/.test(key);
}

function isStoryKey(key) {
  // e.g. 1-6-deploy-and-verify-minimal-application
  return /^\d+-\d+-/.test(key);
}

function getEpicNumberFromStoryKey(storyKey) {
  const match = /^(\d+)-/.exec(storyKey);
  if (!match) return undefined;
  return Number(match[1]);
}

function statusIsDone(status) {
  return status === 'done' || status === 'complete' || status === 'completed';
}

function extractStoryFileStatus(markdown) {
  // Looks for a line like: Status: done
  const match = /^Status:\s*(.+)\s*$/m.exec(markdown);
  if (!match) return undefined;
  return match[1].trim().toLowerCase();
}

function findUncheckedCheckboxes(markdown) {
  // Strict: any unchecked markdown task is considered incomplete.
  // Matches: - [ ] ..., * [ ] ..., 1. [ ] ...
  const matches = [];
  const lines = markdown.split(/\r?\n/);
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i];
    if (/^\s*(?:[-*]|\d+\.)\s+\[ \]\s+/.test(line)) {
      matches.push({ lineNumber: i + 1, line });
    }
  }
  return matches;
}

async function readSprintStatus(statusFilePath) {
  const contents = await fs.readFile(statusFilePath, 'utf8');
  const doc = parseYaml(contents);
  if (!doc || typeof doc !== 'object') {
    throw new Error('sprint-status.yaml did not parse into an object');
  }
  const developmentStatus = doc.development_status;
  if (!developmentStatus || typeof developmentStatus !== 'object') {
    throw new Error('sprint-status.yaml missing development_status');
  }
  return developmentStatus;
}

async function listStoryArtefactFiles(implementationArtifactsDir) {
  const entries = await fs.readdir(implementationArtifactsDir, { withFileTypes: true });
  return entries
    .filter((e) => e.isFile() && e.name.toLowerCase().endsWith('.md'))
    .map((e) => path.join(implementationArtifactsDir, e.name));
}

async function findStoryFileForKey(artefactFiles, storyKey) {
  const matches = artefactFiles.filter((filePath) => {
    const base = path.basename(filePath).toLowerCase();
    const key = storyKey.toLowerCase();
    return base === `${key}.md` || base.startsWith(`${key}-`);
  });

  if (matches.length === 0)
    return { filePath: undefined, error: `No story file found for ${storyKey}` };
  if (matches.length > 1) {
    return {
      filePath: undefined,
      error: `Multiple story files found for ${storyKey}: ${matches.map((m) => path.basename(m)).join(', ')}`,
    };
  }

  return { filePath: matches[0], error: undefined };
}

function inferNextEpicKey(developmentStatus) {
  const epicKeys = Object.keys(developmentStatus).filter(isEpicKey);
  const sorted = epicKeys
    .map((k) => ({ key: k, n: Number(k.split('-')[1]) }))
    .filter((x) => Number.isFinite(x.n))
    .sort((a, b) => a.n - b.n);

  // Next epic: first epic that is still backlog.
  const firstBacklog = sorted.find((e) => developmentStatus[e.key] === 'backlog');
  return firstBacklog?.key;
}

async function main() {
  const { targetEpic } = parseArgs(process.argv.slice(2));

  const sprintStatusPath = path.join(
    repoRoot,
    '_bmad-output',
    'implementation-artifacts',
    'sprint-status.yaml'
  );
  const implementationArtifactsDir = path.join(
    repoRoot,
    '_bmad-output',
    'implementation-artifacts'
  );

  const developmentStatus = await readSprintStatus(sprintStatusPath);

  const targetEpicKey = targetEpic ?? inferNextEpicKey(developmentStatus);
  if (!targetEpicKey) {
    console.error('Epic gate: could not infer target epic (no epic-* entries marked backlog).');
    process.exitCode = 2;
    return;
  }

  if (!isEpicKey(targetEpicKey)) {
    console.error(`Epic gate: invalid --target value: ${targetEpicKey} (expected epic-<n>)`);
    process.exitCode = 2;
    return;
  }

  const targetEpicNumber = Number(targetEpicKey.split('-')[1]);

  const failures = [];

  // Gate 1: all prior epics must be done.
  for (const [key, value] of Object.entries(developmentStatus)) {
    if (!isEpicKey(key)) continue;
    const epicNumber = Number(key.split('-')[1]);
    if (!Number.isFinite(epicNumber)) continue;
    if (epicNumber >= targetEpicNumber) continue;

    if (!statusIsDone(String(value).toLowerCase())) {
      failures.push(`Previous epic ${key} is not done (status: ${value}).`);
    }
  }

  // Gate 2: all prior epic stories must be done (ignore retrospectives, which are optional).
  for (const [key, value] of Object.entries(developmentStatus)) {
    if (isRetrospectiveKey(key)) continue;
    if (!isStoryKey(key)) continue;

    const epicNumber = getEpicNumberFromStoryKey(key);
    if (!epicNumber || epicNumber >= targetEpicNumber) continue;

    if (!statusIsDone(String(value).toLowerCase())) {
      failures.push(`Previous epic story ${key} is not done in sprint status (status: ${value}).`);
    }
  }

  // Gate 3: every prior epic story must have a story artefact markdown file, marked done/complete, with no unchecked tasks.
  const artefactFiles = await listStoryArtefactFiles(implementationArtifactsDir);

  for (const [storyKey, sprintValue] of Object.entries(developmentStatus)) {
    if (isRetrospectiveKey(storyKey)) continue;
    if (!isStoryKey(storyKey)) continue;

    const epicNumber = getEpicNumberFromStoryKey(storyKey);
    if (!epicNumber || epicNumber >= targetEpicNumber) continue;

    const sprintStatus = String(sprintValue).toLowerCase();
    if (!statusIsDone(sprintStatus)) {
      // Already reported in gate 2.
      continue;
    }

    const { filePath: storyFilePath, error } = await findStoryFileForKey(artefactFiles, storyKey);
    if (error) {
      failures.push(error);
      continue;
    }

    const markdown = await fs.readFile(storyFilePath, 'utf8');
    const fileStatus = extractStoryFileStatus(markdown);
    if (!fileStatus) {
      failures.push(
        `Story file ${path.relative(repoRoot, storyFilePath)} missing 'Status: ...' line.`
      );
    } else if (!statusIsDone(fileStatus)) {
      failures.push(
        `Story file ${path.relative(repoRoot, storyFilePath)} status is '${fileStatus}' but sprint-status.yaml says '${sprintStatus}'.`
      );
    }

    const unchecked = findUncheckedCheckboxes(markdown);
    if (unchecked.length > 0) {
      const examples = unchecked
        .slice(0, 3)
        .map((m) => `${path.relative(repoRoot, storyFilePath)}:${m.lineNumber} ${m.line.trim()}`)
        .join('\n');
      failures.push(
        `Story file ${path.relative(repoRoot, storyFilePath)} has unchecked tasks (${unchecked.length}).\n${examples}`
      );
    }
  }

  if (failures.length > 0) {
    console.error(`Epic gate failed for target ${targetEpicKey}. Fix these before moving on:`);
    for (const failure of failures) {
      console.error(`- ${failure}`);
    }
    process.exitCode = 1;
    return;
  }

  console.log(`Epic gate passed. Safe to start ${targetEpicKey}.`);
}

await main();

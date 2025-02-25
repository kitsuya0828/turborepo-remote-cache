const core = require('@actions/core');
const github = require('@actions/github');
const { spawn } = require('child_process');
const path = require('path');
const fetch = require('node-fetch');
const { env } = require('turborepo-remote-cache');

const TURBO_TOKEN = 'turbo-token';
const PORT = core.getInput('port');
const GOOGLE_CLOUD_PROJECT = core.getInput('google_cloud_project', { required: true });
const GOOGLE_APPLICATION_CREDENTIALS = core.getInput('google_application_credentials', { required: true });
const STORAGE_PATH = core.getInput('storage_path', { required: true });

async function checkHealth() {
  console.log("Waiting for server to become healthy...");
  for (let i = 1; i <= 10; i++) {
    try {
      const response = await fetch(`http://localhost:${PORT}/v8/artifacts/status`);
      const status = response.status;
      console.log(`Attempt ${i}: Received status code ${status}`);
      if (status === 200) {
        console.log("Server is healthy.");
        process.exit(0);
      }
    } catch (error) {
      console.log(`Attempt ${i}: Error occurred. Retrying in 1 second...`);
    }
    await new Promise(resolve => setTimeout(resolve, 1000));  // Sleep for 1 second
  }
  console.log("Server health check failed after 10 attempts.");
  process.exit(1);
}

async function run() {
  try {
    console.log(typeof env);
    core.exportVariable('TURBO_TOKEN', TURBO_TOKEN);
    core.exportVariable('TURBO_API', `http://localhost:${PORT}`);
    const { repo } = github.context.repo;
    core.exportVariable('TURBO_TEAM', repo);

    const command = 'npx';
    const args = ['turborepo-remote-cache'];
    core.info(`Starting turborepo-remote-cache with command: ${command} ${args.join(' ')}`);
    const serverProcess = spawn(command, args, {
      stdio: 'inherit',
      detached: true,
      shell: true,
      env: {
          PATH: process.env.PATH + ':' + path.dirname(process.execPath),
          PORT: PORT,
          TURBO_TOKEN: TURBO_TOKEN, 
          GOOGLE_CLOUD_PROJECT: GOOGLE_CLOUD_PROJECT,
          STORAGE_PROVIDER: "google-cloud-storage",
          GOOGLE_APPLICATION_CREDENTIALS: GOOGLE_APPLICATION_CREDENTIALS,
          STORAGE_PATH: STORAGE_PATH,
      }
    });
    serverProcess.unref();
    core.info(`turborepo-remote-cache started (PID: ${serverProcess.pid})`);
    core.setOutput("server-pid", serverProcess.pid);
    await new Promise(resolve => setTimeout(resolve, 1000));
    await checkHealth();
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();

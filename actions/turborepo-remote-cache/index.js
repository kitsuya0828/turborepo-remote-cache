const core = require('@actions/core');
// const github = require('@actions/github');
const { spawn } = require('child_process');
const path = require('path');
const fetch = require('node-fetch');

const PORT = 3001;

async function checkHealth() {
  core.info("Waiting for server to become healthy...");
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
    // // `who-to-greet` input defined in action metadata file
    // const nameToGreet = core.getInput('who-to-greet');
    // console.log(`Hello ${nameToGreet}!`);
    // const time = (new Date()).toTimeString();
    // core.setOutput("time", time);
    // // Get the JSON webhook payload for the event that triggered the workflow
    // const payload = JSON.stringify(github.context.payload, undefined, 2)
    // console.log(`The event payload: ${payload}`);
    const command = 'npx';
    const args = ['turborepo-remote-cache'];
    core.info(`Starting turborepo-remote-cache with command: ${command} ${args.join(' ')}`);
    const serverProcess = spawn(command, args, {
      stdio: 'inherit',
      detached: true,
      shell: true,
      env: {
          PORT: PORT,
          TURBO_TOKEN: "turbo-token",
          PATH: process.env.PATH + ':' + path.dirname(process.execPath)
      }
    });
    serverProcess.unref();
    core.info(`turborepo-remote-cache started (PID: ${serverProcess.pid})`);
    core.setOutput("server-pid", serverProcess.pid);
    await checkHealth();
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();

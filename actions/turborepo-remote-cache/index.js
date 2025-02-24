const core = require('@actions/core');
// const github = require('@actions/github');
const { spawn } = require('child_process');

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
          PORT: "3001",
          TURBO_TOKEN: "turbo-token",
      }
    });
    await new Promise(resolve =>  setTimeout(resolve, 3000));
    core.info(`turborepo-remote-cache started (PID: ${serverProcess.pid})`);
    core.setOutput("server-pid", serverProcess.pid);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();

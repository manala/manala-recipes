const core = require('@actions/core');
const exec = require('@actions/exec');
const os = require('node:os');

exports.core = core

exports.run = async ({ dir, docker_dir, docker_env, run } = {}) => {
  process.stdout.write('[command]' + run.split(os.EOL, 1)[0] + os.EOL)
  // See: https://github.com/actions/toolkit/issues/649
  const { stdout } = await exec.getExecOutput('make', ['sh'], {
    'cwd': dir,
    'input': Buffer.from(run, 'utf-8'),
    'env': {
      // See: https://github.com/actions/toolkit/issues/1158
      ...process.env,
      'MANALA_DOCKER_COMMAND_DIR': docker_dir,
      'MANALA_DOCKER_COMMAND_ENV': docker_env,
    },
    'silent': true,
  });
  process.stdout.write(stdout)
}

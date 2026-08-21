const system = require('../../system/module');
const core = system.core

const path = require('node:path');
const app = core.getInput('docker_dir')

system.run({
    'dir': core.getInput('dir'),
    'docker_dir': path.join('/srv/app', app),
    'docker_env': 'XDG_CACHE_HOME=' + path.join('/srv/cache', app ? app : 'project'),
    'run': core.getInput('run'),
});

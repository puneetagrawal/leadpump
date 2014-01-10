listen 80

worker_processes 3

preload_app true

#user nobody nogroup; # for systems with a "nogroup"
# user nobody nobody; # for systems with "nobody" as a group instead

# Feel free to change all paths to suite your needs here, of course
#pid /path/to/nginx.pid;
pid 'tmp/pids/unicorn.pid'

stderr_path 'log/unicorn.log'
stdout_path 'log/unicorn.log'
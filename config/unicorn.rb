root = "/root/leadpump"
working_directory root
pid "#{root}/tmp/pids/unicorn_leadpump.pid"
listen "/tmp/unicorn.leadpump.sock"

stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

worker_processes 2
timeout 30

root = "/root/leadpump"

working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"
#listen "127.0.0.1:8080"
listen "/tmp/unicorn.leadpump.sock"
worker_processes 2
timeout 30

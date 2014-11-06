# This file is used by Rack-based servers to start the application.

# Unicorn self-process killer
require 'unicorn/worker_killer'

# Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, 3072, 4096

# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (192*(1024**2)), (256*(1024**2)), check_cycle = 16, verbose = true

require ::File.expand_path('../config/environment',  __FILE__)
run Leadpump::Application

use Rack::Cors do
  allow do
    origins 'localhost:3000', '127.0.0.1:3000',
            /http:\/\/192\.168\.0\.\d{1,3}(:\d+)?/
            # regular expressions can be used here

    resource '/file/list_all/', :headers => 'x-domain-token'
    resource '/file/at/*',
        :methods => [:get, :post, :put, :delete, :options],
        :headers => 'x-domain-token',
        :expose  => ['Some-Custom-Response-Header'],
        :max_age => 600
        # headers to expose
  end

  allow do
    origins '*'
    resource '/public/*', :headers => :any, :methods => :get
  end
end

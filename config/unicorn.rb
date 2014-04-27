app_path = File.expand_path('../..', __FILE__)

# Set unicorn options
worker_processes ENV['UNICORN_COUNT'] || 1
timeout 180

if ENV['RACK_ENV'] == 'production'
  preload_app true
  user 'ruby_virt', 'ruby_virt'
  # Log everything to one file
  stderr_path "#{app_path}/log/unicorn.log"
  stdout_path "#{app_path}/log/unicorn.log"
  listen "#{app_path}/tmp/sockets/unicorn.sock"
end

# Fill path to your app
working_directory app_path

# Set master PID location
pid "#{app_path}/tmp/pids/unicorn.pid"

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
end

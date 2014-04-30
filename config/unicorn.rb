# unicorn config
app_path = File.expand_path('../..', __FILE__)
working_directory app_path
worker_processes (ENV['UNICORN_COUNT'] || 1).to_i
pid "#{app_path}/tmp/pids/unicorn.#{ENV['RACK_ENV']}.pid"
timeout 180

unless %w{ development test }.include?(ENV['RACK_ENV'])
  preload_app true
  user "ruby_virt_#{ENV['RACK_ENV']}", "ruby_virt_#{ENV['RACK_ENV']}"
  stderr_path "#{app_path}/log/unicorn.#{ENV['RACK_ENV']}.log"
  stdout_path "#{app_path}/log/unicorn.#{ENV['RACK_ENV']}.log"
  listen "#{app_path}/tmp/sockets/unicorn.#{ENV['RACK_ENV']}.sock"
end

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

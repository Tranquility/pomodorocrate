# Minimal sample configuration file for Unicorn (not Rack) when used
# with daemonization (unicorn -D) started in your working directory.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
# See also http://unicorn.bogomips.org/examples/unicorn.conf.rb for
# a more verbose configuration using more features.

rails_root = File.expand_path('../..', __FILE__)
app_port = ENV.fetch('PORT', 3000).to_i
pid_path = File.join(rails_root, 'tmp', 'pids', "unicorn-#{app_port}.pid")
log_dir = File.join(rails_root, 'log')

# Prepare directories if missing
[File.dirname(pid_path), log_dir].each do |path| FileUtils.mkdir_p(path) end

worker_processes ENV.fetch('UNICORNS', 2).to_i # this should be >= nr_cpus
listen app_port
pid pid_path
stderr_path File.join(log_dir, 'unicorn.log')
stdout_path File.join(log_dir, 'unicorn.log')

# Preload our app for more speed
preload_app true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

before_fork do |server, worker|
  # dump our worker pids so that monit (or others) can monitor them.
  child_pid = server.config[:pid].sub('.pid', "-#{worker.nr}.pid")
  File.open(child_pid, 'w') { |f| f.write(Process.pid) }

  # the following is highly recommended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid_path = "#{pid_path}.oldbin"
  if File.exists?(old_pid_path) && server.pid != old_pid_path
    begin
      Process.kill("QUIT", File.read(old_pid_path).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end

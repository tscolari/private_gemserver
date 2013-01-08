worker_processes 2
preload_app true

shared_path = "/home/gem/deploy/shared"
current_path= "/home/gem/deploy/current"

# Restart any workers that haven't responded in 30 seconds
timeout 30

# Listen on a Unix data socket
listen "#{shared_path}/sockets/unicorn.sock", :backlog => 2048
user    'gem', 'gem'

stderr_path "#{current_path}/log/unicorn_site.stderr.log"
stdout_path "#{current_path}/log/unicorn_site.stdout.log"

pid     File.join(shared_path, "pids/unicorn.pid")

before_fork do |server, worker|
  old_pid = File.join(shared_path, 'pids/unicorn.pid.oldbin')
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end


after_fork do |server, worker|
end

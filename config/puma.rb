# threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
# environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Allow puma to be restarted by `rails restart` command.
environment ENV.fetch("RAILS_ENV") { "production" }
rails_env = ENV.fetch("RAILS_ENV") { "production" }
if rails_env == "production"
    app_dir = File.expand_path("../..", __FILE__)
    bind "unix://#{app_dir}/tmp/sockets/puma.sock"
    pidfile "#{app_dir}/tmp/pids/puma.pid"
    state_path "#{app_dir}/tmp/pids/puma.state"
    stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true
    threads_count =  5
    threads threads_count, threads_count
end

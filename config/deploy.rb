default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :application, "pomodorocrate"
set :repository,  "git://github.com/reveloper/ketchup.git"
set :deploy_to, "/var/www/vhosts/pomodorocrate.com/rails/#{application}"
set :user, "asalceanu"  # The server's user for deploys

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server "pomodorocrate.com", :web, :app, :db, :primary => true

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
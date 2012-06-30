Pomodoro Crate
===============

What is it?
----------
First version of the Pomodoro Crate app - my first Rails app, used as a learning device. Far from perfect but does a good job.

Open sourcing it due to multiple requests and lack of time to maintain it.

Please push back your fixes and additions.

[http://pomodorocrate.com](http://pomodorocrate.com)

Installation
------------
You will need ruby (1.9.3 recommended) and the 'bundle' gem installed.

    $ git clone git://github.com/reveloper/pomodorocrate.git
    $ cd pomodorocrate
    $ bundle install --path vendor/bundle

Initial setup
-------------
You need to configure email adress for Pomodorocrate or the application won't run the first time.
Copy `.env.sample` to `.env` and configure at least the `EMAIL_DEFAULT` variable.
If you use an external SMTP server such as gmail follow the instructions in the `.env` comments.

Quick run
---------
This will run PomodoroCrate in the development mode, using sqlite3 database in `db/development.db`

    $ bundle exec rake db:migrate
    $ bundle exec foreman start -p 3000
    $ tail -f log/development.log

Finally, open `http://localhost:3000/` with your favorite browser.

Production setup
----------------
These steps will setup to run `script/unicorn` in production mode. Configuration is loaded from the `.env` file.

    # create the production database if needed
    # edit Gemfile to enable the adapter for your favorite database (default: sqlite3)
    # edit config/database.yml to configure for your production database
    $ RAILS_ENV=production bundle exec rake db:migrate
    $ # edit `.env` to tailor it to your environment (environment, ports, relative root, smtp etc..)
    $ script/unicorn start
    $ tail -f log/unicorn.log log/production.log

You may run `bundle exec foreman start` as an alternative to `script/unicorn`, as both methods load environment from the `.env` file.

Finally, open `http://localhost:$PORT/` with your favorite browser. If you do not see any images or styles this is normal, as static assets are not served by the rails server in the production environment by default (they should instead be served directly by the frontend server).

You should consider:

* serving static resources using a web server such as [apache](http://httpd.apache.org/) or [nginx](http://wiki.nginx.org/) and proxy everything else to the application server.
* using a real database rather than sqlite3; [mysql](http://www.mysql.com) and [postgresql](http://www.postgresql.org) are supported.
* monitoring your PomodoroCrate server with tools like [monit](http://mmonit.com/monit) (`bundle exec foreman export` may be useful).

Tip:

* to enable Google Analytics in production, set `GA_ACCOUNT` and `GA_DOMAIN` environment variables in your `.env` file.

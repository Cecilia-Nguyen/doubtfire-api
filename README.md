![Doubtfire Logo](http://puu.sh/lyClF/fde5bfbbe7.png)

# Doubtfire API

A modern, lightweight learning management system.

## Getting started

### OS X

#### 1. Install Homebrew and Homebrew Cask

Install [Homebrew](http://brew.sh) for easy package management, if you haven't already, as well as [Homebrew Cask](http://caskroom.io):

```
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew install caskroom/cask/brew-cask
```

#### 2. Install rbenv and ruby-build

Install [rbenv](https://github.com/sstephenson/rbenv) and ruby-build:

```
$ brew install ruby-build rbenv
```

Add the following to your `.bashrc`:

```
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
```

_or_, if you're using [Oh-My-Zsh](http://ohmyz.sh), add to your `.zshrc`:

```
$ echo 'eval "$(rbenv init -)"' >> ~/.zshrc
```

Now install Ruby v2.0.0-p353:

```
$ rbenv install 2.0.0-p353
```

#### 3. Install Postgres

Install the [Postgres App](http://postgresapp.com):

```
$ brew cask install postgres --appdir=/Applications
```

Ensure `pg_config` is on the `PATH`, and then login to Postgres:

```
$ export PATH=/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH
$ psql
```

Create the Doubfire user the following at the Postgres prompt:

```
CREATE ROLE itig WITH CREATEDB PASSWORD 'd872$dh' LOGIN;
```

#### 4. Install native tools

Install imagemagick, libmagic, and pdftk:

```
$ brew tap docmunch/pdftk
$ brew install imagemagick libmagic pdftk
```

This step may take up to 20 minutes to complete as the pdftk compilation process is slow. Refer to the GitHub issue [here](https://github.com/docmunch/homebrew-pdftk/issues/5).

#### 5. Install Doubtfire API dependencies

Clone project and change your working directory to the api:

```
$ git clone https://[user]@bitbucket.org/itig/doubtfire-api.git
$ cd ./doubtfire-api
```

Then install Doubtfire API dependencies using [bundler](http://bundler.io):

```
$ gem install bundler
$ bundle install --without production test replica
```

##### Bundle resolutions

You may encounter build issues when using Homebrew/Homebrew Cask to install dependencies. Some resolutions to these are listed below:

###### eventmachine

The `eventmachine` gem cannot find `openssl/ssl.h` when compiling with native extensions:

```
Installing eventmachine 1.0.3 with native extensions

...


make "DESTDIR="
compiling binder.cpp
In file included from binder.cpp:20:
./project.h:107:10: fatal error: 'openssl/ssl.h' file not found
#include <openssl/ssl.h>
         ^
1 error generated.
make: *** [binder.o] Error 1
```

To resolve, add the following to your global bundle config:

```
$ bundle config build.eventmachine --with-cppflags=-I/usr/local/opt/openssl/include
```

Then try installing dependencies again.

###### pg

The `pg` gem cannot find `pg_config` when compiling with native extensions:

```
Installing pg 0.17.1 with native extensions

Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.

    /Users/[User]/.rbenv/versions/2.0.0-p353/bin/ruby extconf.rb
checking for pg_config... no
No pg_config... trying anyway. If building fails, please try again with
 --with-pg-config=/path/to/pg_config
checking for libpq-fe.h... no
Can't find the 'libpq-fe.h header
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of necessary
libraries and/or headers.  Check the mkmf.log file for more details.  You may
need configuration options.
```

To resolve, ensure `pg_config` is on the `PATH`:

```
$ export PATH=/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH
```

_or_, add the following to your global bundle config:

```
$ bundle config build.pg --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.4/bin/pg_config
```

You may need to confirm the `Postgres.app` version (it may not be `9.4`).

Then try installing dependencies again.

###### ruby-filemagic

The `ruby-filemagic` gem cannot find `libmagic` libraries when compiling with native extensions:

```
Installing ruby-filemagic 0.6.0 with native extensions

Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.

    /Users/[User]/.rbenv/versions/2.0.0-p353/bin/ruby extconf.rb
checking for magic_open() in -lmagic... no
checking for magic.h... no
*** ERROR: missing required library to compile this module
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of necessary
libraries and/or headers.  Check the mkmf.log file for more details.  You may
need configuration options.
```

To resolve, add the following to your global bundle config:

```
$ bundle config build.ruby-filemagic --with-magic-include=/usr/local/include --with-magic-lib=/usr/local/opt/libmagic/lib
```

Then try installing dependencies again.

#### 6. Create and populate Doubtfire development databases

Whilst still in the Doubtfire API project root, execute:

```
$ rake db:create
$ rake db:populate
```

#### 7. Get it up and running!

Run the Rails server and check the API is up by viewing Grape Swagger documentation:

```
$ rails s
$ open http://localhost:3000/api/docs/
```

You should see all the Doubtfire endpoints here, which means the API is running.

### Linux

#### 1. Install rbenv and ruby-build

Install [rbenv](https://github.com/sstephenson/rbenv) and ruby-build:

```
$ sudo apt-get update
$ sudo apt-get install ruby-build rbenv
```

Add the following to your `.bashrc`:

```
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
```

_or_, if you're using [Oh-My-Zsh](http://ohmyz.sh), add to your `.zshrc`:

```
$ echo 'eval "$(rbenv init -)"' >> ~/.zshrc
```

Now install Ruby v2.0.0-p353:

```
$ rbenv install 2.0.0-p353
```

#### 3. Install Postgres

Install [Postgres](http://www.postgresql.org/download/linux/):

```
$ sudo apt-get install postgresql postgresql-contrib
```

Ensure `pg_config` is on the `PATH`, and then login to Postgres. You will need to locate where `apt-get` has installed your  Postgres binary and add this to your `PATH`. You can use `whereis psql` for that, but ensure you add the directory and not the executable to the path

```
$ whereis pqsl

/usr/bin/psql

$ export PATH=/usr/bin:$PATH
$ psql
```

Create the Doubfire user the following at the Postgres prompt:

```
CREATE ROLE itig WITH CREATEDB PASSWORD 'd872$dh' LOGIN;
```

#### 4. Install native tools

Install imagemagick, libmagic, and pdftk:

```
$ sudo apt-get install imagemagick --fix-missing
$ sudo apt-get install libmagic-dev
$ sudo apt-get install pdftk
```

#### 5. Install Doubtfire API dependencies

Clone project and change your working directory to the api:

```
$ git clone https://[user]@bitbucket.org/itig/doubtfire-api.git
$ cd ./doubtfire-api
```

Then install Doubtfire API dependencies using [bundler](http://bundler.io):

```
$ gem install bundler
$ bundle install --without production test replica
```

#### 6. Create and populate Doubtfire development databases

Whilst still in the Doubtfire API project root, execute:

```
$ rake db:create
$ rake db:populate
```

#### 7. Get it up and running!

Run the Rails server and check the API is up by viewing Grape Swagger documentation:

```
$ rails s
$ open http://localhost:3000/api/docs/
```

You should see all the Doubtfire endpoints here, which means the API is running.

## Rake Tasks

You can perform developer-specific tasks using `rake`. For a list of all tasks, execute in the root directory:

```
rake --tasks
```

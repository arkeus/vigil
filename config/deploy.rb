# RVM

#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, 'default'
set :rvm_type, :user

# Bundler

require "bundler/capistrano"

# General

set :application, "vigil"
set :user, "arkeus"

set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :copy

set :use_sudo, false

# Git

set :scm, :git
set :repository,  "C:/Dev/Workspace/Rails/Vigil/.git"
#set :repository,  "~/Documents/Workspace/Vigil/.git"
set :branch, "master"

# VPS

role :web, "198.211.99.199"
role :app, "198.211.99.199"
role :db,  "198.211.99.199", :primary => true
role :db,  "198.211.99.199"

# Passenger

namespace :deploy do
 task :start do ; end
 task :stop do ; end
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 end
end
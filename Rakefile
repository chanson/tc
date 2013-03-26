#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rake/testtask'

Tc::Application.load_tasks

Rake::Task[:test].clear # clear previous test task definition
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
  t.libs.push 'test'
end

Rake.application.instance_variable_get('@tasks').delete('default')
task :default => [:test]

require "rubygems"
require "bundler"
Bundler.require(:default, ENV["RACK_ENV"] || :development)

require "sinatra/activerecord/rake"

namespace :db do
  task :load_config do
    require "./site"
  end
end

desc "Run a local server."
task :local do
  Kernel.exec("shotgun -s thin -p 9393")
end

desc "Scrape a hashtag"
task :cron => ["db:load_config"] do
  puts "TODO: IMPLEMENT."
end

desc "Generate random string."
task :secret do
  require 'securerandom'
  puts SecureRandom.hex(128).split('').sample(64).join('')
end

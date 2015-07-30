require "rubygems"
require "bundler"
Bundler.require(:default, ENV["RACK_ENV"] || :development)

configure do
  RACK_ENV = (ENV['RACK_ENV'] || :development).to_sym
  connections = {
    :development => "postgres://localhost/okrclub",
    :test => "postgres://postgres@localhost/okrclub_test",
    :production => ENV['DATABASE_URL']
  }
  url = URI(connections[RACK_ENV])
  options = {
    :adapter => url.scheme,
    :host => url.host,
    :port => url.port,
    :database => url.path[1..-1],
    :username => url.user,
    :password => url.password
  }

  case url.scheme
  when "sqlite"
    options[:adapter] = "sqlite3"
    options[:database] = url.host + url.path
  when "postgres"
    options[:adapter] = "postgresql"
  end
  set :database, options
end

get "/" do
  erb :index
end

error 400..510 do
  @code = response.status
  erb :error
end

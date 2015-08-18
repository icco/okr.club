require "rubygems"
require "bundler"
Bundler.require(:default, ENV["RACK_ENV"] || :development)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

configure do

  # Logging
  $logger = Logger.new(STDOUT)

  # Sessions
  secret = ENV["SESSION_SECRET"] || "secret"
  $logger.warn "Session secret is not secure!" if secret.eql? "secret"
  use Rack::Session::Cookie, :expire_after => 14400, :secret => "secret"

  # Those popup messages
  use Rack::Flash

  # Configure Database
  RACK_ENV = (ENV["RACK_ENV"] || :development).to_sym
  connections = {
    :development => "postgres://localhost/okrclub",
    :test => "postgres://postgres@localhost/okrclub_test",
    :production => ENV["DATABASE_URL"]
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

  # Configure Warden (Authentication)
  # Use this with env["warden"].authenticate!
  use Warden::Manager do |config|
    # serialize user to session ->
    config.serialize_into_session{|user| user.id}
    # serialize user from session <-
    config.serialize_from_session{|id| User.get(id) }
    # configuring strategies
    config.scope_defaults :default,
      strategies: [:password],
      action: "auth/unauthenticated"
    config.failure_app = self
  end

  Warden::Strategies.add(:password) do
    def flash
      env["x-rack.flash"]
    end

    # valid params for authentication
    def valid?
      params["user"] && params["user"]["username"] && params["user"]["password"]
    end

    # authenticating user
    def authenticate!
      # find for user
      user = User.where(name: params["user"]["username"]).first
      if user.nil?
        fail!("Invalid username, does not exists!")
        flash[:error] = ""
      elsif user.authenticate(params["user"]["password"])
        flash[:success] = "Logged in"
        success!(user)
      else
        fail!("There are errors, please try again")
      end
    end
  end
end

get "/" do
  erb :index
end

get "/login" do
  redirect "/auth/login"
end

get "/signup" do
  redirect "/auth/signup"
end

get "/auth/login" do
  erb :login
end

post "/auth/login" do
  env["warden"].authenticate!

  flash[:success] = env["warden"].message

  if session[:return_to].nil?
    redirect "/home"
  else
    redirect session[:return_to]
  end
end

# Required by Warden for when user reach a protected route watched by Warden
# calls.
post "/auth/unauthenticated" do
  session[:return_to] = env["warden.options"][:attempted_path]
  puts env["warden.options"][:attempted_path]
  flash[:error] = env["warden"].message  || "You must to login to continue"
  redirect "/auth/login"
end

# Required by Warden to ensure user logout a session data removal.
get "/auth/logout" do
  env["warden"].raw_session.inspect
  env["warden"].logout
  flash[:success] = "Successfully logged out"
  redirect "/"
end

error 400..510 do
  @code = response.status
  erb :error
end

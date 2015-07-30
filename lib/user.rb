class User < ActiveRecord::Base
  # users.password_hash in the database is a :string
  include BCrypt

  has_many :objectives

  def self.authenticate(name, password)
    user = self.first(name: name)
    user if user && user.password == password
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  # for future use
  def forgot_password
    @user = User.find_by_email(params[:email])
    random_password = Array.new(10).map { (65 + rand(58)).chr }.join
    @user.password = random_password
    @user.save!
    Mailer.create_and_deliver_password_change(@user, random_password)
  end
end

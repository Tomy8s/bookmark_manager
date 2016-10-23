require_relative 'data_mapper_setup'
require 'bcrypt'

class User

  attr_reader :password
  attr_accessor :password_confirmation

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  include DataMapper::Resource

  validates_confirmation_of :password, message: 'Passwords do not match. Please try again'
  validates_presence_of :email, :password, message: 'Please enter a valid email address'
  validates_uniqueness_of :email

  property :id, Serial
  property :email, String, required: true, unique: true, format: :email_address
  property :password_digest, Text
end

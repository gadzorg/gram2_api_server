class Client < ActiveRecord::Base
  rolify
  acts_as_token_authenticatable

  validates :email, :presence => false

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

class Client < ActiveRecord::Base
  rolify
  acts_as_token_authenticatable

  validates :email, :presence => false

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable

  #this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    super && active?
  end

  def active?
    self.active
  end

  # Override some Rolify class ton restrict roles types
  def add_role(role_name, resource = nil)
    if resource == nil
      super if Role.list_availables.include? [role_name]
    else
      super if Role.list_availables.include? [role_name, resource]
    end
  end


end

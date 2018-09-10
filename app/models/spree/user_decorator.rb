Spree::User.class_eval do
  has_many :roles, through: :role_users
end
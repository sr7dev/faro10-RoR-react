class Admin < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :secure_validatable, :timeoutable, :trackable
end

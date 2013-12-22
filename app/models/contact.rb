class Contact < ActiveRecord::Base
  attr_accessible :email, :name, :phone, :position
  has_many :events
end

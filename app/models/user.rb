class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
		 
		 
  has_many :notes

  # 1:1 relationship with profile to be implemented 
  has_one :profile
  accepts_nested_attributes_for :profile
  
end

class User < ActiveRecord::Base
  has_many :wikis
  after_initialize { self.role ||= :standard }
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable




  enum[:standard, :premium, :admin]


end

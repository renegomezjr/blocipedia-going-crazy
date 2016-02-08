class User < ActiveRecord::Base
  has_many :wikis, through: :collaborators
  has_many :collaborators, dependent: :destroy
  after_initialize { self.role ||= :standard }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable




  enum role: [:standard, :premium, :admin]


end

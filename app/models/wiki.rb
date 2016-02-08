class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :users, through: :collaborators
  has_many :collaborators, dependent: :destroy
  default_scope { order('created_at DESC')}
  scope :visible_to, -> (user) {(user.premium? || user.admin?) ? all : where(:private => false) }

  def priv_pub
    private ? "Private" : "Public"
  end

end

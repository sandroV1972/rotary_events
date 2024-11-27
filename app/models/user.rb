#class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
#  devise :database_authenticatable, :registerable,
#         :recoverable, :rememberable, :validatable
#    has_many :guests
#  end
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :role, optional: true
  has_many :guests

  validates :first_name, :last_name, presence: true

  # Method to check if the user is an admin
  def admin?
    role&.name == 'admin'
  end
  
  # Full name method
  def full_name
    "#{first_name} #{last_name}"
  end
end
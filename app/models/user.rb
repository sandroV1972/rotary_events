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

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role_id, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?


  # Method to check if the user is an admin
  def admin?
    role&.name == 'admin'
  end
  
  def role_name
    role.name
  end

  # Full name method
  def full_name
    "#{first_name} #{last_name}"
  end
end
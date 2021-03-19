class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  enum role: { general: 0, admin: 1 }

  def to_param
    name
  end
end

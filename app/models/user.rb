class User < ApplicationRecord
  has_secure_password

  if :role == "owner"
    has_one :office
  end

  # Validations
  validates :email, uniqueness: true, presence: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :role, presence: true
  validates_inclusion_of :role, in: ["owner", "customer"]
  
  def to_token_payload
    {
      sub: id,
      email: email
    }
  end
end

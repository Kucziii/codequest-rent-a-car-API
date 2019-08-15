class User < ApplicationRecord
  has_secure_password

  has_one :office

  # Validations
  validates :email, uniqueness: true, presence: true

  def to_token_payload
    {
      sub: id,
      email: email
    }
  end
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter, :github]

  has_many :messages

  def update_from_google_oauth_hash(oauth_hash)
      self.email ||= oauth_hash.info.email
      self.oauth_google = oauth_hash.credentials.token
      self.save
      self
  end
end

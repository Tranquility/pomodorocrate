# == Schema Information
# Schema version: 20110116094444
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :confirmation_hash, :reset_password_hash, :time_zone, :email_notifications, :voice_notifications
  
  has_many :projects,   :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :todotodays, :dependent => :destroy
  has_many :pomodoros,  :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
                    
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
                    
  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
                       
  validates_inclusion_of :time_zone, :in => ActiveSupport::TimeZone.all.map { |z| z.name }, :message => "is not a valid time zone" #, :allow_nil => true, :allow_blank => true
                       
  before_save :encrypt_password, :check_account_confirmed
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def make_reset_password_hash
    self.reset_password_hash = encrypt(email)
  end

  private
    
    def check_account_confirmed
      self.confirmation_hash = encrypt(email) if new_record?
    end

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
  
end

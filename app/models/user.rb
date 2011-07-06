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
  
  attr_accessible :name, :email, :password, :password_confirmation, :confirmation_hash, :reset_password_hash, :time_zone, :email_notifications, :voice_notifications, :pomodoro_length, :short_break_length, :long_break_length, :account_id, :tick_tack_sound, :api_key
  
  after_initialize :setup_user_settings
  before_save :encrypt_password, :check_account_confirmed #, :save_settings
  after_create :create_settings
  
  has_many :projects,   :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :todotodays, :dependent => :destroy
  has_many :pomodoros,  :dependent => :destroy
  has_many :interruptions, :dependent => :destroy

  has_one :setting,     :dependent => :destroy

  belongs_to :account
  
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
                                                
  validate :must_have_valid_settings
  
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
  
  # api key
  def enable_api!
    self.generate_api_key!
  end

  def disable_api!
    self.update_attribute(:api_key, nil)
  end

  def api_is_enabled?
    !(self.api_key.nil? || self.api_key.empty?)
  end
  # end api key
  
  protected

    def s_digest(*args)
      Digest::SHA1.hexdigest(args.flatten.join('--'))
    end

    def generate_api_key!
      self.update_attribute(:api_key, s_digest(Time.now, (1..10).map{ rand.to_s }))
    end

  private
    
    def check_account_confirmed
      self.confirmation_hash = encrypt(email) if new_record?
    end

    def encrypt_password
      return encrypted_password if (password.nil? or password.empty?)
      
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
    
    def setup_user_settings
      return if self.new_record? or self.setting.nil?
        
      #+TODO for back compatibility with the settings kept in the users model - to be removed gradually
      # setup the user with the settings
      self.email_notifications  = self.setting.email_notifications
      self.voice_notifications  = self.setting.voice_notifications
      self.pomodoro_length  = self.setting.pomodoro_length
      self.short_break_length  = self.setting.short_break_length
      self.long_break_length  = self.setting.long_break_length
      self.tick_tack_sound  = self.setting.tick_tack_sound
    end
    
    def save_settings
      #self.setting.save
    end
    
    def must_have_valid_settings
      #self.setting.tooltips = self.tooltips
      #self.setting.height   = self.height
      
      #unless self.setting.valid? 
        #self.setting.errors.each {|k, v| errors.add(k, v) } 
      #end
    end
    
    def create_settings
      self.setting = Setting.new
    end
  
end

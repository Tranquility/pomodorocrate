# used in the site, outside the app, for contact requests
class Contact < ActiveRecord::Base
  
  def self.columns
    @columns ||= [];
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  # Override the save method to prevent exceptions.
  def save(validate = true)
    validate ? valid? : true
  end
  
  column :name,       :string
  column :email,      :string
  column :message,    :text
  column :debug_info, :text
  
  attr_accessible :name, :email, :message, :debug_info
  
  validates_presence_of :name, :email, :message
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\z/
  
end

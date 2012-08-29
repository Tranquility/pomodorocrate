module UsersHelper
  
  def gravatar_for( user, options = { :size => 50 } )
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end

  def user_widget_for( user, options = { :size => 16 } )
    content_tag( :span, gravatar_for( user, options ) + link_to( user.name, user ) )
  end
  
end

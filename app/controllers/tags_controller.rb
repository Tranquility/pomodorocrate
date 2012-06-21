class TagsController < ApplicationController
  
  def user_tags
    user_tags = tags(Activity.where(:user_id => current_user.id), params[:term])
    user_tags = user_tags.collect { |ut| { :value => ut.name, :name => ut.name } }
    
    respond_to do |format|
      #format.js { render :text => '{items: ' + user_tags.to_json + '}' }
      format.js { render :json => user_tags.to_json }
    end
  end

  def activity_tags
    user_tags = tags Activity.find(params[:id])
  end

  def project_tags
  end
  
  
  private 
  
    def tags(tagged_objects, filter)
      # get the taggings for the current user activities
      taggings = Tagging.find(:all, :select => 'tag_id', :conditions => ["taggable_id IN (?)", tagged_objects.collect { |a| a.id } ] )

      # now get the tags
      Tag.find(:all, :select => 'name', :conditions => ["id in (?) AND name LIKE ?", taggings.collect { |t| t.tag_id }, ('%' + filter + '%') ])
    end

end
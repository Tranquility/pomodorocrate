class AnalyticsController < ApplicationController
  
  before_filter :authenticate
  #before_filter :correct_user
  
  def index
    if params[:q_interval].to_i != 7 and params[:q_interval].to_i != 30 and params[:q_interval].to_i != 1
      params[:q_interval] = 7
    end
    
    pomodoros_tags_filtering = ''
    activities_tag_filtering = ''
    if params[:q_tags] and params[:q_tags] != 'Tags.' and !params[:q_tags].blank? 
      activities = Activity.find_tagged_with(params[:q_tags])
      
      pomodoros_tags_filtering = 'pomodoros.activity_id IN (?)', activities.collect { |a| a.id }
      activities_tag_filtering = 'activities.id IN (?)', activities.collect { |a| a.id }
    end
    
    project_filtering = ''
    if params[:q_project] and params[:q_project] != '__none__'
      project_filtering = 'activities.project_id = ?', params[:q_project]
    end
    
    @graph_interval = params[:q_interval].to_i
    
    @start_date = @graph_interval.days.ago.to_date
    @end_date = Date.tomorrow
    
    @complete_pomodoros = self.complete_pomodoros(current_user, @start_date..@end_date, true, pomodoros_tags_filtering, project_filtering)
    @void_pomodoros = self.complete_pomodoros(current_user, @start_date..@end_date, false, pomodoros_tags_filtering, project_filtering)
    
    @estimated_pomodoros = self.estimated_pomodoros(current_user, @start_date..@end_date, activities_tag_filtering, project_filtering)
    
    @worked_time = self.worked_time(current_user, @start_date..@end_date, pomodoros_tags_filtering, project_filtering)
    
    @planned_activities = self.activities(current_user, @start_date..@end_date, false, activities_tag_filtering, project_filtering)
    @unplanned_activities = self.activities(current_user, @start_date..@end_date, true, activities_tag_filtering, project_filtering)
    
    @internal_interruptions = self.interruptions(current_user, @start_date..@end_date, :internal, pomodoros_tags_filtering, project_filtering)
    @external_interruptions = self.interruptions(current_user, @start_date..@end_date, :external, pomodoros_tags_filtering, project_filtering)
    
    @total_completed_pomodoros = Pomodoro.joins(:activity => :project).where(:user_id => current_user.id, :completed => true, :successful => true, :created_at => @start_date..@end_date).where(project_filtering).where(pomodoros_tags_filtering).count()
    @total_worked_minutes = Pomodoro.joins(:activity => :project).where(:user_id => current_user.id, :completed => true, :successful => true, :created_at => @start_date..@end_date).where(project_filtering).where(pomodoros_tags_filtering).sum(:duration)
    @total_worked_activities = Pomodoro.joins(:activity => :project).where(:user_id => current_user.id, :completed => true, :successful => true, :created_at => @start_date..@end_date).where(project_filtering).where(pomodoros_tags_filtering).count(:group => :activity).length
    @total_worked_projects = Pomodoro.joins(:activity => :project).where(:user_id => current_user.id, :completed => true, :successful => true, :created_at => @start_date..@end_date).where(project_filtering).where(pomodoros_tags_filtering).count(:group => 'activities.project_id').length
    
    respond_to do |format|
      format.js     {  }
      format.html   # index.html.erb
      format.xml    {  }
      format.json   {  }
    end
    
  end
  
  def render_complete_pomodoros
    @complete_pomodoros = self.complete_pomodoros(current_user, params[:start_date]..params[:end_date])
    
    respond_to do |format|
      format.xml  { render :xml => @complete_pomodoros }
    end
  end
  
  protected
    
    def complete_pomodoros(current_user, created_at, successful, pomodoros_tags_filtering, project_filtering)
      Pomodoro.joins(:activity => :project).where(:user_id => current_user.id, :completed => true, :successful => successful, :created_at => created_at).where(project_filtering).where(pomodoros_tags_filtering).count(:group => "date(pomodoros.created_at)")
    end
    
    def estimated_pomodoros(current_user, updated_at, activities_tag_filtering, project_filtering)
      unscoped_activities.select(:estimated_pomodoros).where(:user_id => current_user.id, :updated_at => updated_at).where(project_filtering).group("date(activities.updated_at)").where(activities_tag_filtering).sum(:estimated_pomodoros)
    end
    
    def worked_time(current_user, created_at, pomodoros_tags_filtering, project_filtering)
      Pomodoro.joins(:activity => :project).where(:user_id => current_user.id, :completed => true, :successful => true, :created_at => created_at).where(project_filtering).where(pomodoros_tags_filtering).group("date(pomodoros.created_at)").sum(:duration)
    end
    
    def activities(current_user, created_at, unplanned, activities_tag_filtering, project_filtering)
      unscoped_activities.where(:user_id => current_user.id, :unplanned => unplanned, :created_at => created_at).where(project_filtering).where(activities_tag_filtering).count(:group => "date(activities.created_at)")
    end
    
    def interruptions(current_user, created_at, kind, pomodoros_tags_filtering, project_filtering)
      return Interruption.joins(:pomodoro => :activity).where(:user_id => current_user.id, :kind => kind, :created_at => created_at).where(project_filtering).where(pomodoros_tags_filtering).count(:group => "date(interruptions.created_at)") if pomodoros_tags_filtering.blank?
      Interruption.joins(:pomodoro => :activity).where(:user_id => current_user.id, :kind => kind, :created_at => created_at).where(project_filtering).where(pomodoros_tags_filtering).count(:group => "date(interruptions.created_at)")
    end

    def unscoped_activities
      # when we request count(:group => 'DATE(created_at)') or other calculated expression
      # postgres will complain about invalid sql. the reason is that Activity model has a
      # default_scope that references columns that are not part of AREL-generated select
      # (specifically the default_scope adds order by custom priority). some databases may
      # tolerate the invalid sql by not postgres! => we kill default_scope with unscoped.
      # XXX: all these calculations should be done in the model with a domain object.
      Activity.unscoped
    end
end

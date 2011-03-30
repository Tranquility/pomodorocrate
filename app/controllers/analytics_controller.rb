class AnalyticsController < ApplicationController
  
  before_filter :authenticate
  #before_filter :correct_user
  
  def index
    if params[:q_interval].to_i != 7 and params[:q_interval].to_i != 30
      params[:q_interval] = 7
    end
    
    @graph_interval = params[:q_interval].to_i
    
    @start_date = @graph_interval.days.ago.to_date
    @end_date = Date.tomorrow
    
    @complete_pomodoros = self.complete_pomodoros(current_user, @start_date..@end_date, true)
    @void_pomodoros = self.complete_pomodoros(current_user, @start_date..@end_date, false)
    
    @estimated_pomodoros = self.estimated_pomodoros(current_user, @start_date..@end_date)
    
    @worked_time = self.worked_time(current_user, @start_date..@end_date)
    
    @planned_activities = self.activities(current_user, @start_date..@end_date, false)
    @unplanned_activities = self.activities(current_user, @start_date..@end_date, true)
    
    @internal_interruptions = self.interruptions(current_user, @start_date..@end_date, :internal)
    @external_interruptions = self.interruptions(current_user, @start_date..@end_date, :external)
  end
  
  def render_complete_pomodoros
    @complete_pomodoros = self.complete_pomodoros(current_user, params[:start_date]..params[:end_date])
    
    respond_to do |format|
      format.xml  { render :xml => @complete_pomodoros }
    end
  end
  
  protected
    
    def complete_pomodoros(current_user, created_at, successful)
      Pomodoro.where(:user_id => current_user.id, :completed => true, :successful => successful, :created_at => created_at).count(:group => "date(pomodoros.created_at)")
    end
    
    def estimated_pomodoros(current_user, updated_at)
      Activity.select(:estimated_pomodoros).where(:user_id => current_user.id, :updated_at => updated_at).group("date(activities.updated_at)").sum(:estimated_pomodoros)
    end
    
    def worked_time(current_user, created_at)
      Pomodoro.where(:user_id => current_user.id, :completed => true, :successful => true, :created_at => created_at).group("date(pomodoros.created_at)").sum(:duration)
    end
    
    def activities(current_user, created_at, unplanned)
      Activity.where(:user_id => current_user.id, :unplanned => unplanned, :created_at => created_at).count(:group => "date(activities.created_at)")
    end
    
    def interruptions(current_user, created_at, kind)
      Interruption.where(:user_id => current_user.id, :kind => kind, :created_at => created_at).count(:group => "date(interruptions.created_at)")
    end

end

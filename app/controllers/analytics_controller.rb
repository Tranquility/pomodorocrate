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
    
    @complete_pomodoros = self.complete_pomodoros(current_user, @start_date..@end_date)
    @void_pomodoros = self.void_pomodoros(current_user, @start_date..@end_date)
    
    @estimated_pomodoros = self.estimated_pomodoros(current_user, @start_date..@end_date)
    
    @worked_time = self.worked_time(current_user, @start_date..@end_date)
  end
  
  def render_complete_pomodoros
    @complete_pomodoros = self.complete_pomodoros(current_user, params[:start_date]..params[:end_date])
    
    respond_to do |format|
      format.xml  { render :xml => @complete_pomodoros }
    end
  end
  
  protected
    
    def complete_pomodoros(current_user, created_at)
      Pomodoro.where(:user_id => current_user.id, :completed => true, :successful => true, :created_at => created_at).count(:group => "date(pomodoros.created_at)")
    end
    
    def void_pomodoros(current_user, created_at)
      Pomodoro.where(:user_id => current_user.id, :completed => true, :successful => false, :created_at => created_at).count(:group => "date(pomodoros.created_at)")
    end
    
    def estimated_pomodoros(current_user, updated_at)
      Activity.select(:estimated_pomodoros).where(:user_id => current_user.id, :updated_at => updated_at).group("date(activities.updated_at)").sum(:estimated_pomodoros)
    end
    
    def worked_time(current_user, created_at)
      Pomodoro.where(:user_id => current_user.id, :completed => true, :successful => true, :created_at => created_at).group("date(pomodoros.created_at)").sum(:duration)
    end

end

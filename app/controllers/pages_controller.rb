class PagesController < HighVoltage::PagesController
  layout 'site'
  
  def home
    redirect_to activities_path if signed_in?
    @title = 'Welcome!'
  end
end


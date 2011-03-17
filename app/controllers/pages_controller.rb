class PagesController < HighVoltage::PagesController
  layout "static"
  
  def home
    redirect_to activities_path if signed_in?
  end
end


class HelpController < ApplicationController

  before_filter :authenticate

  def index
    
    respond_to do |format|
      format.js     {  }
      format.html   # index.html.erb
      format.xml    {  }
      format.json   {  }
    end
  end

end

module BreaksHelper
  
  def break_in_progress?
    b = Break.where( :completed => nil ).first
    !b.nil?
  end
  
end

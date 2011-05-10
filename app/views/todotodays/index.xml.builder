xml.instruct! :xml, :version=>"1.0"

xml.todotodays do
  @todotodays.each do |todotoday|
    xml.todotoday do
        xml.activity-id todotoday.activity.id
    end
  end
end
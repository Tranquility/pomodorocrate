require 'spec_helper'

describe "breaks/new.html.erb" do
  before(:each) do
    assign(:break, stub_model(Break,
      :completed => false
    ).as_new_record)
  end

  it "renders new break form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => breaks_path, :method => "post" do
      assert_select "input#break_completed", :name => "break[completed]"
    end
  end
end

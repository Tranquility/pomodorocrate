require 'spec_helper'

describe "breaks/edit.html.erb" do
  before(:each) do
    @break = assign(:break, stub_model(Break,
      :completed => false
    ))
  end

  it "renders the edit break form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => break_path(@break), :method => "post" do
      assert_select "input#break_completed", :name => "break[completed]"
    end
  end
end

require 'spec_helper'

describe "breaks/show.html.erb" do
  before(:each) do
    @break = assign(:break, stub_model(Break,
      :completed => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end

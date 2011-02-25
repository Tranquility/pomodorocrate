require 'spec_helper'

describe "contact_requests/index.html.erb" do
  before(:each) do
    assign(:contact_requests, [
      stub_model(ContactRequest,
        :content => "MyText",
        :bug => false,
        :feature_request => false,
        :suggestion => false,
        :user => nil
      ),
      stub_model(ContactRequest,
        :content => "MyText",
        :bug => false,
        :feature_request => false,
        :suggestion => false,
        :user => nil
      )
    ])
  end

  it "renders a list of contact_requests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

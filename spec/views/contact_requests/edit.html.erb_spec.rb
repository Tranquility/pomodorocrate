require 'spec_helper'

describe "contact_requests/edit.html.erb" do
  before(:each) do
    @contact_request = assign(:contact_request, stub_model(ContactRequest,
      :content => "MyText",
      :bug => false,
      :feature_request => false,
      :suggestion => false,
      :user => nil
    ))
  end

  it "renders the edit contact_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => contact_request_path(@contact_request), :method => "post" do
      assert_select "textarea#contact_request_content", :name => "contact_request[content]"
      assert_select "input#contact_request_bug", :name => "contact_request[bug]"
      assert_select "input#contact_request_feature_request", :name => "contact_request[feature_request]"
      assert_select "input#contact_request_suggestion", :name => "contact_request[suggestion]"
      assert_select "input#contact_request_user", :name => "contact_request[user]"
    end
  end
end

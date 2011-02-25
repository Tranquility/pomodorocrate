require 'spec_helper'

describe "contact_requests/new.html.erb" do
  before(:each) do
    assign(:contact_request, stub_model(ContactRequest,
      :content => "MyText",
      :bug => false,
      :feature_request => false,
      :suggestion => false,
      :user => nil
    ).as_new_record)
  end

  it "renders new contact_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => contact_requests_path, :method => "post" do
      assert_select "textarea#contact_request_content", :name => "contact_request[content]"
      assert_select "input#contact_request_bug", :name => "contact_request[bug]"
      assert_select "input#contact_request_feature_request", :name => "contact_request[feature_request]"
      assert_select "input#contact_request_suggestion", :name => "contact_request[suggestion]"
      assert_select "input#contact_request_user", :name => "contact_request[user]"
    end
  end
end

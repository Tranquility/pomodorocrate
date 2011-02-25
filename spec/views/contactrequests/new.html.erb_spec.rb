require 'spec_helper'

describe "contactrequests/new.html.erb" do
  before(:each) do
    assign(:contactrequest, stub_model(Contactrequest,
      :content => "MyText",
      :bug => false,
      :feature_request => false,
      :suggestion => false,
      :user => nil
    ).as_new_record)
  end

  it "renders new contactrequest form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => contactrequests_path, :method => "post" do
      assert_select "textarea#contactrequest_content", :name => "contactrequest[content]"
      assert_select "input#contactrequest_bug", :name => "contactrequest[bug]"
      assert_select "input#contactrequest_feature_request", :name => "contactrequest[feature_request]"
      assert_select "input#contactrequest_suggestion", :name => "contactrequest[suggestion]"
      assert_select "input#contactrequest_user", :name => "contactrequest[user]"
    end
  end
end

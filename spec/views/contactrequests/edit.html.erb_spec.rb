require 'spec_helper'

describe "contactrequests/edit.html.erb" do
  before(:each) do
    @contactrequest = assign(:contactrequest, stub_model(Contactrequest,
      :content => "MyText",
      :bug => false,
      :feature_request => false,
      :suggestion => false,
      :user => nil
    ))
  end

  it "renders the edit contactrequest form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => contactrequest_path(@contactrequest), :method => "post" do
      assert_select "textarea#contactrequest_content", :name => "contactrequest[content]"
      assert_select "input#contactrequest_bug", :name => "contactrequest[bug]"
      assert_select "input#contactrequest_feature_request", :name => "contactrequest[feature_request]"
      assert_select "input#contactrequest_suggestion", :name => "contactrequest[suggestion]"
      assert_select "input#contactrequest_user", :name => "contactrequest[user]"
    end
  end
end

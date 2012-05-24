require 'spec_helper'

describe "beings/edit" do
  before(:each) do
    @being = assign(:being, stub_model(Being,
      :name => "MyString",
      :gender => "MyString",
      :age => ""
    ))
  end

  it "renders the edit being form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => beings_path(@being), :method => "post" do
      assert_select "ul.form"
      #assert_select "input#_gender"
      #assert_select "input#_age"
    end
  end
end

require 'spec_helper'

describe "beings/index" do
  before(:each) do
    assign(:beings, [
      stub_model(Being,
        :name => "Name",
        :gender => "Gender",
        :age => ""
      ),
      stub_model(Being,
        :name => "Name",
        :gender => "Gender",
        :age => ""
      )
    ])
  end

  it "renders a list of beings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end

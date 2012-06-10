require 'spec_helper'

describe "buildings/index" do
  before(:each) do
    assign(:buildings, [
      stub_model(Building,
        :description => "Description",
        :x => 1,
        :y => 2
      ),
      stub_model(Building,
        :description => "Description",
        :x => 1,
        :y => 2
      )
    ])
  end

  it "renders a list of buildings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end

require 'spec_helper'

describe "events/index" do
  before(:each) do
    assign(:events, [
      stub_model(Event,
        :name => "Name",
        :description => "Description",
        :occured_on => "Occured On"
      ),
      stub_model(Event,
        :name => "Name",
        :description => "Description",
        :occured_on => "Occured On"
      )
    ])
  end

  it "renders a list of events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Occured On".to_s, :count => 2
  end
end

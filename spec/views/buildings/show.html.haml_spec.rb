require 'spec_helper'

describe "buildings/show" do
  before(:each) do
    @building = assign(:building, stub_model(Building,
      :description => "Description",
      :x => 1,
      :y => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end

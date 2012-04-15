require 'spec_helper'

describe "damages/index" do
  before(:each) do
    assign(:damages, [
      stub_model(Damage,
        :duration => 1,
        :description => "Description"
      ),
      stub_model(Damage,
        :duration => 1,
        :description => "Description"
      )
    ])
  end

  it "renders a list of damages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end

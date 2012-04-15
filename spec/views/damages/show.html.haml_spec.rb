require 'spec_helper'

describe "damages/show" do
  before(:each) do
    @damage = assign(:damage, stub_model(Damage,
      :duration => 1,
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Description/)
  end
end

require 'spec_helper'

describe "beings/show" do
  before(:each) do
    @being = FactoryGirl.create(:being)
    @being.randomize!
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Family/)
    rendered.should match(/History/)
  end
end

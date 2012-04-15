require 'spec_helper'

describe "beings/show" do
  before(:each) do
    @being = assign(:being, stub_model(Being,
      :name => "Name",
      :gender => "Gender",
      :age => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Gender/)
    rendered.should match(//)
  end
end

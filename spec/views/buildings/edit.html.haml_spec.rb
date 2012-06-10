require 'spec_helper'

describe "buildings/edit" do
  before(:each) do
    @building = assign(:building, stub_model(Building,
      :description => "MyString",
      :x => 1,
      :y => 1
    ))
  end

  it "renders the edit building form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => buildings_path(@building), :method => "post" do
      assert_select "input#building_description", :name => "building[description]"
      assert_select "input#building_x", :name => "building[x]"
      assert_select "input#building_y", :name => "building[y]"
    end
  end
end

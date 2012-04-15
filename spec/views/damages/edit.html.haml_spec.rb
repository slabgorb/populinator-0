require 'spec_helper'

describe "damages/edit" do
  before(:each) do
    @damage = assign(:damage, stub_model(Damage,
      :duration => 1,
      :description => "MyString"
    ))
  end

  it "renders the edit damage form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => damages_path(@damage), :method => "post" do
      assert_select "input#damage_duration", :name => "damage[duration]"
      assert_select "input#damage_description", :name => "damage[description]"
    end
  end
end

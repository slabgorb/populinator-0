require 'spec_helper'

describe "beings/show" do
  before(:each) do
    @being = FactoryGirl.create(:being)
    @being.randomize!
  end


end

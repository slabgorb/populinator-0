require "spec_helper"

describe DamagesController do
  describe "routing" do

    it "routes to #index" do
      get("/damages").should route_to("damages#index")
    end

    it "routes to #new" do
      get("/damages/new").should route_to("damages#new")
    end

    it "routes to #show" do
      get("/damages/1").should route_to("damages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/damages/1/edit").should route_to("damages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/damages").should route_to("damages#create")
    end

    it "routes to #update" do
      put("/damages/1").should route_to("damages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/damages/1").should route_to("damages#destroy", :id => "1")
    end

  end
end

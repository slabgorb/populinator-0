require "spec_helper"

describe BeingsController do
  describe "routing" do

    it "routes to #index" do
      get("/beings").should route_to("beings#index")
    end

    it "routes to #new" do
      get("/beings/new").should route_to("beings#new")
    end

    it "routes to #show" do
      get("/beings/1").should route_to("beings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/beings/1/edit").should route_to("beings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/beings").should route_to("beings#create")
    end

    it "routes to #update" do
      put("/beings/1").should route_to("beings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/beings/1").should route_to("beings#destroy", :id => "1")
    end

  end
end

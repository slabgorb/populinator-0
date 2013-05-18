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

    it "routes to #kill" do
      put("/beings/kill/1").should route_to("beings#kill", id: "1")
    end
    it "routes to #resurrect" do
      put("/beings/resurrect/1").should route_to("beings#resurrect", id: "1")
    end

    it "routes to #reproduce" do
      put("/beings/reproduce/1/2").should route_to("beings#reproduce", parent_a: "1", parent_b: "2")
    end

    it "routes to #random_name" do
      get("/people/random-name").should route_to("people#random_name")
    end
    it "routes to #history" do
      get("/beings/history/1").should route_to("beings#history", id: "1")
    end



  end
end

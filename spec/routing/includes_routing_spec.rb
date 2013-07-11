require "spec_helper"

describe IncludesController do
  describe "routing" do

    it "routes to #index" do
      get("/includes").should route_to("includes#index")
    end

    it "routes to #new" do
      get("/includes/new").should route_to("includes#new")
    end

    it "routes to #show" do
      get("/includes/1").should route_to("includes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/includes/1/edit").should route_to("includes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/includes").should route_to("includes#create")
    end

    it "routes to #update" do
      put("/includes/1").should route_to("includes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/includes/1").should route_to("includes#destroy", :id => "1")
    end

  end
end

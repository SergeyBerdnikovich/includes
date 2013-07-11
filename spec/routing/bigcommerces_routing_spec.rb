require "spec_helper"

describe BigcommercesController do
  describe "routing" do

    it "routes to #index" do
      get("/bigcommerces").should route_to("bigcommerces#index")
    end

    it "routes to #new" do
      get("/bigcommerces/new").should route_to("bigcommerces#new")
    end

    it "routes to #show" do
      get("/bigcommerces/1").should route_to("bigcommerces#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bigcommerces/1/edit").should route_to("bigcommerces#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bigcommerces").should route_to("bigcommerces#create")
    end

    it "routes to #update" do
      put("/bigcommerces/1").should route_to("bigcommerces#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bigcommerces/1").should route_to("bigcommerces#destroy", :id => "1")
    end

  end
end

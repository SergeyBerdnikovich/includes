require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe StatisticsController do

  # This should return the minimal set of attributes required to create a valid
  # Statistic. As you add validations to Statistic, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "include_id" => "1" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # StatisticsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all statistics as @statistics" do
      statistic = Statistic.create! valid_attributes
      get :index, {}, valid_session
      assigns(:statistics).should eq([statistic])
    end
  end

  describe "GET show" do
    it "assigns the requested statistic as @statistic" do
      statistic = Statistic.create! valid_attributes
      get :show, {:id => statistic.to_param}, valid_session
      assigns(:statistic).should eq(statistic)
    end
  end

  describe "GET new" do
    it "assigns a new statistic as @statistic" do
      get :new, {}, valid_session
      assigns(:statistic).should be_a_new(Statistic)
    end
  end

  describe "GET edit" do
    it "assigns the requested statistic as @statistic" do
      statistic = Statistic.create! valid_attributes
      get :edit, {:id => statistic.to_param}, valid_session
      assigns(:statistic).should eq(statistic)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Statistic" do
        expect {
          post :create, {:statistic => valid_attributes}, valid_session
        }.to change(Statistic, :count).by(1)
      end

      it "assigns a newly created statistic as @statistic" do
        post :create, {:statistic => valid_attributes}, valid_session
        assigns(:statistic).should be_a(Statistic)
        assigns(:statistic).should be_persisted
      end

      it "redirects to the created statistic" do
        post :create, {:statistic => valid_attributes}, valid_session
        response.should redirect_to(Statistic.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved statistic as @statistic" do
        # Trigger the behavior that occurs when invalid params are submitted
        Statistic.any_instance.stub(:save).and_return(false)
        post :create, {:statistic => { "include_id" => "invalid value" }}, valid_session
        assigns(:statistic).should be_a_new(Statistic)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Statistic.any_instance.stub(:save).and_return(false)
        post :create, {:statistic => { "include_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested statistic" do
        statistic = Statistic.create! valid_attributes
        # Assuming there are no other statistics in the database, this
        # specifies that the Statistic created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Statistic.any_instance.should_receive(:update_attributes).with({ "include_id" => "1" })
        put :update, {:id => statistic.to_param, :statistic => { "include_id" => "1" }}, valid_session
      end

      it "assigns the requested statistic as @statistic" do
        statistic = Statistic.create! valid_attributes
        put :update, {:id => statistic.to_param, :statistic => valid_attributes}, valid_session
        assigns(:statistic).should eq(statistic)
      end

      it "redirects to the statistic" do
        statistic = Statistic.create! valid_attributes
        put :update, {:id => statistic.to_param, :statistic => valid_attributes}, valid_session
        response.should redirect_to(statistic)
      end
    end

    describe "with invalid params" do
      it "assigns the statistic as @statistic" do
        statistic = Statistic.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Statistic.any_instance.stub(:save).and_return(false)
        put :update, {:id => statistic.to_param, :statistic => { "include_id" => "invalid value" }}, valid_session
        assigns(:statistic).should eq(statistic)
      end

      it "re-renders the 'edit' template" do
        statistic = Statistic.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Statistic.any_instance.stub(:save).and_return(false)
        put :update, {:id => statistic.to_param, :statistic => { "include_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested statistic" do
      statistic = Statistic.create! valid_attributes
      expect {
        delete :destroy, {:id => statistic.to_param}, valid_session
      }.to change(Statistic, :count).by(-1)
    end

    it "redirects to the statistics list" do
      statistic = Statistic.create! valid_attributes
      delete :destroy, {:id => statistic.to_param}, valid_session
      response.should redirect_to(statistics_url)
    end
  end

end

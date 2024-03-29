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

describe BigcommercesController do

  # This should return the minimal set of attributes required to create a valid
  # Bigcommerce. As you add validations to Bigcommerce, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "store_url" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BigcommercesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all bigcommerces as @bigcommerces" do
      bigcommerce = Bigcommerce.create! valid_attributes
      get :index, {}, valid_session
      assigns(:bigcommerces).should eq([bigcommerce])
    end
  end

  describe "GET show" do
    it "assigns the requested bigcommerce as @bigcommerce" do
      bigcommerce = Bigcommerce.create! valid_attributes
      get :show, {:id => bigcommerce.to_param}, valid_session
      assigns(:bigcommerce).should eq(bigcommerce)
    end
  end

  describe "GET new" do
    it "assigns a new bigcommerce as @bigcommerce" do
      get :new, {}, valid_session
      assigns(:bigcommerce).should be_a_new(Bigcommerce)
    end
  end

  describe "GET edit" do
    it "assigns the requested bigcommerce as @bigcommerce" do
      bigcommerce = Bigcommerce.create! valid_attributes
      get :edit, {:id => bigcommerce.to_param}, valid_session
      assigns(:bigcommerce).should eq(bigcommerce)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Bigcommerce" do
        expect {
          post :create, {:bigcommerce => valid_attributes}, valid_session
        }.to change(Bigcommerce, :count).by(1)
      end

      it "assigns a newly created bigcommerce as @bigcommerce" do
        post :create, {:bigcommerce => valid_attributes}, valid_session
        assigns(:bigcommerce).should be_a(Bigcommerce)
        assigns(:bigcommerce).should be_persisted
      end

      it "redirects to the created bigcommerce" do
        post :create, {:bigcommerce => valid_attributes}, valid_session
        response.should redirect_to(Bigcommerce.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bigcommerce as @bigcommerce" do
        # Trigger the behavior that occurs when invalid params are submitted
        Bigcommerce.any_instance.stub(:save).and_return(false)
        post :create, {:bigcommerce => { "store_url" => "invalid value" }}, valid_session
        assigns(:bigcommerce).should be_a_new(Bigcommerce)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Bigcommerce.any_instance.stub(:save).and_return(false)
        post :create, {:bigcommerce => { "store_url" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bigcommerce" do
        bigcommerce = Bigcommerce.create! valid_attributes
        # Assuming there are no other bigcommerces in the database, this
        # specifies that the Bigcommerce created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Bigcommerce.any_instance.should_receive(:update_attributes).with({ "store_url" => "MyString" })
        put :update, {:id => bigcommerce.to_param, :bigcommerce => { "store_url" => "MyString" }}, valid_session
      end

      it "assigns the requested bigcommerce as @bigcommerce" do
        bigcommerce = Bigcommerce.create! valid_attributes
        put :update, {:id => bigcommerce.to_param, :bigcommerce => valid_attributes}, valid_session
        assigns(:bigcommerce).should eq(bigcommerce)
      end

      it "redirects to the bigcommerce" do
        bigcommerce = Bigcommerce.create! valid_attributes
        put :update, {:id => bigcommerce.to_param, :bigcommerce => valid_attributes}, valid_session
        response.should redirect_to(bigcommerce)
      end
    end

    describe "with invalid params" do
      it "assigns the bigcommerce as @bigcommerce" do
        bigcommerce = Bigcommerce.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Bigcommerce.any_instance.stub(:save).and_return(false)
        put :update, {:id => bigcommerce.to_param, :bigcommerce => { "store_url" => "invalid value" }}, valid_session
        assigns(:bigcommerce).should eq(bigcommerce)
      end

      it "re-renders the 'edit' template" do
        bigcommerce = Bigcommerce.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Bigcommerce.any_instance.stub(:save).and_return(false)
        put :update, {:id => bigcommerce.to_param, :bigcommerce => { "store_url" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bigcommerce" do
      bigcommerce = Bigcommerce.create! valid_attributes
      expect {
        delete :destroy, {:id => bigcommerce.to_param}, valid_session
      }.to change(Bigcommerce, :count).by(-1)
    end

    it "redirects to the bigcommerces list" do
      bigcommerce = Bigcommerce.create! valid_attributes
      delete :destroy, {:id => bigcommerce.to_param}, valid_session
      response.should redirect_to(bigcommerces_url)
    end
  end

end

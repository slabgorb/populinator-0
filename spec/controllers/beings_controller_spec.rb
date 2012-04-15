require 'spec_helper'



describe BeingsController do

  # This should return the minimal set of attributes required to create a valid
  # Being. As you add validations to Being, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:name =>'Adam', :gender => 'male', :age => 1}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BeingsController. Be sure to keep this updated too.
  def valid_session
    {}
  end
  
  describe "GET index" do
    it "assigns all beings as @beings" do
      being = Being.create! valid_attributes
      get :index, {}, valid_session
      assigns(:beings).should eq([being])
    end
  end
  
  describe "GET show" do
    it "assigns the requested being as @being" do
      being = Being.create! valid_attributes
      get :show, {:id => being.to_param}, valid_session
      assigns(:being).should eq(being)
    end
  end

  describe "GET new" do
    it "assigns a new being as @being" do
      get :new, {}, valid_session
      assigns(:being).should be_a_new(Being)
    end
  end

  describe "GET edit" do
    it "assigns the requested being as @being" do
      being = Being.create! valid_attributes
      get :edit, {:id => being.to_param}, valid_session
      assigns(:being).should eq(being)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Being" do
        expect {
          post :create, {:being => valid_attributes}, valid_session
        }.to change(Being, :count).by(1)
      end

      it "assigns a newly created being as @being" do
        post :create, {:being => valid_attributes}, valid_session
        assigns(:being).should be_a(Being)
        assigns(:being).should be_persisted
      end

      it "redirects to the created being" do
        post :create, {:being => valid_attributes}, valid_session
        response.should redirect_to(Being.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved being as @being" do
        # Trigger the behavior that occurs when invalid params are submitted
        Being.any_instance.stub(:save).and_return(false)
        post :create, {:being => {}}, valid_session
        assigns(:being).should be_a_new(Being)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Being.any_instance.stub(:save).and_return(false)
        post :create, {:being => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested being" do
        being = Being.create! valid_attributes
        # Assuming there are no other beings in the database, this
        # specifies that the Being created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Being.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => being.to_param, :being => {'these' => 'params'}}, valid_session
      end

      # it "assigns the requested being as @being" do
      #   being = Being.create! valid_attributes
      #   put :update, {:id => being.to_param, :being => valid_attributes}, valid_session
      #   assigns(:being).should eq(being)
      # end

      # it "redirects to the being" do
      #   being = Being.create! valid_attributes
      #   put :update, {:id => being.to_param, :being => valid_attributes}, valid_session
      #   response.should redirect_to(being)
      # end
    end

    describe "with invalid params" do
      it "assigns the being as @being" do
        being = Being.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Being.any_instance.stub(:save).and_return(false)
        put :update, {:id => being.to_param, :being => {}}, valid_session
        assigns(:being).should eq(being)
      end

      it "re-renders the 'edit' template" do
        being = Being.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Being.any_instance.stub(:save).and_return(false)
        put :update, {:id => being.to_param, :being => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested being" do
      being = Being.create! valid_attributes
      expect {
        delete :destroy, {:id => being.to_param}, valid_session
      }.to change(Being, :count).by(-1)
    end

    it "redirects to the beings list" do
      being = Being.create! valid_attributes
      delete :destroy, {:id => being.to_param}, valid_session
      response.should redirect_to(beings_url)
    end
  end

end

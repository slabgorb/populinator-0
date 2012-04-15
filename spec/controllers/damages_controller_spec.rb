require 'spec_helper'

describe DamagesController do

  # This should return the minimal set of attributes required to create a valid
  # Damage. As you add validations to Damage, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DamagesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all damages as @damages" do
      damage = Damage.create! valid_attributes
      get :index, {}, valid_session
      assigns(:damages).should eq([damage])
    end
  end

  describe "GET show" do
    it "assigns the requested damage as @damage" do
      damage = Damage.create! valid_attributes
      get :show, {:id => damage.to_param}, valid_session
      assigns(:damage).should eq(damage)
    end
  end

  describe "GET new" do
    it "assigns a new damage as @damage" do
      get :new, {}, valid_session
      assigns(:damage).should be_a_new(Damage)
    end
  end

  describe "GET edit" do
    it "assigns the requested damage as @damage" do
      damage = Damage.create! valid_attributes
      get :edit, {:id => damage.to_param}, valid_session
      assigns(:damage).should eq(damage)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Damage" do
        expect {
          post :create, {:damage => valid_attributes}, valid_session
        }.to change(Damage, :count).by(1)
      end

      it "assigns a newly created damage as @damage" do
        post :create, {:damage => valid_attributes}, valid_session
        assigns(:damage).should be_a(Damage)
        assigns(:damage).should be_persisted
      end

      it "redirects to the created damage" do
        post :create, {:damage => valid_attributes}, valid_session
        response.should redirect_to(Damage.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved damage as @damage" do
        # Trigger the behavior that occurs when invalid params are submitted
        Damage.any_instance.stub(:save).and_return(false)
        post :create, {:damage => {}}, valid_session
        assigns(:damage).should be_a_new(Damage)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Damage.any_instance.stub(:save).and_return(false)
        post :create, {:damage => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested damage" do
        damage = Damage.create! valid_attributes
        # Assuming there are no other damages in the database, this
        # specifies that the Damage created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Damage.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => damage.to_param, :damage => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested damage as @damage" do
        damage = Damage.create! valid_attributes
        put :update, {:id => damage.to_param, :damage => valid_attributes}, valid_session
        assigns(:damage).should eq(damage)
      end

      it "redirects to the damage" do
        damage = Damage.create! valid_attributes
        put :update, {:id => damage.to_param, :damage => valid_attributes}, valid_session
        response.should redirect_to(damage)
      end
    end

    describe "with invalid params" do
      it "assigns the damage as @damage" do
        damage = Damage.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Damage.any_instance.stub(:save).and_return(false)
        put :update, {:id => damage.to_param, :damage => {}}, valid_session
        assigns(:damage).should eq(damage)
      end

      it "re-renders the 'edit' template" do
        damage = Damage.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Damage.any_instance.stub(:save).and_return(false)
        put :update, {:id => damage.to_param, :damage => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested damage" do
      damage = Damage.create! valid_attributes
      expect {
        delete :destroy, {:id => damage.to_param}, valid_session
      }.to change(Damage, :count).by(-1)
    end

    it "redirects to the damages list" do
      damage = Damage.create! valid_attributes
      delete :destroy, {:id => damage.to_param}, valid_session
      response.should redirect_to(damages_url)
    end
  end

end

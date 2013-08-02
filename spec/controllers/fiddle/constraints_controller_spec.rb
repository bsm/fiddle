require 'spec_helper'

describe Fiddle::ConstraintsController do

  let :constraint do
    create :constraint
  end

  let :cube do
    constraint.cube
  end

  describe "GET index" do
    before do
      constraint # create one
      get :index, cube_id: cube.to_param, use_route: :fiddle
    end

    it { assigns[:constraints].should == [constraint] }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe "GET show" do
    before do
      get :show, id: constraint.to_param, use_route: :fiddle
    end

    it { assigns[:constraint].should == constraint }
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "GET new" do
    before do
      get :new, cube_id: cube.to_param, use_route: :fiddle
    end

    it { assigns[:constraint].should be_present }
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end

  describe "POST create" do
    before do
      attrs = build(:constraint, projection: create(:projection, cube: cube)).attributes
      post :create, cube_id: cube.to_param, constraint: attrs, use_route: :fiddle
    end

    let :last_added do
      Fiddle::Constraint.order(:id).last
    end

    it { assigns[:constraint].should == last_added }
    it { should redirect_to("/my/constraints/#{last_added.to_param}") }
    it { should permit_params(:name, :projection_id, :operation_code).for(:constraint) } if Fiddle.strong_parameters?
  end

  describe "GET edit" do
    before do
      get :edit, id: constraint.to_param, use_route: :fiddle
    end

    it { assigns[:constraint].should == constraint }
    it { should respond_with(:success) }
    it { should render_template(:edit) }
  end

  describe "PUT update" do
    before do
      put :update, id: constraint.to_param, use_route: :fiddle,
        constraint: constraint.attributes.slice('name', 'projection_id', 'operation_code')
    end

    it { assigns[:constraint].should == constraint }
    it { should redirect_to("/my/constraints/#{constraint.to_param}") }
    it { should permit_params(:name, :projection_id, :operation_code).for(:constraint) } if Fiddle.strong_parameters?
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, id: constraint.to_param, use_route: :fiddle
    end

    it { assigns[:constraint].should == constraint }
    it { should redirect_to("/my/cubes/#{cube.to_param}/constraints") }
  end

end

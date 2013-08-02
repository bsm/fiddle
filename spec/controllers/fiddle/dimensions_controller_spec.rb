require 'spec_helper'

describe Fiddle::DimensionsController do

  let :dimension do
    create :dimension
  end

  let :cube do
    dimension.cube
  end

  describe "GET index" do
    before do
      dimension # create one
      get :index, cube_id: cube.to_param, use_route: :fiddle
    end

    it { assigns[:dimensions].should == [dimension] }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe "GET show" do
    before do
      get :show, id: dimension.to_param, use_route: :fiddle
    end

    it { assigns[:dimension].should == dimension }
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "GET new" do
    before do
      get :new, cube_id: cube.to_param, use_route: :fiddle
    end

    it { assigns[:dimension].should be_present }
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end

  describe "POST create" do
    before do
      attrs = attributes_for :dimension, cube: nil, clause: "#{cube.name}.some_col"
      attrs.merge! description: 'Some Col Description', visible: true, sortable: true
      post :create, cube_id: cube.to_param, dimension: attrs, use_route: :fiddle
    end

    let :last_added do
      Fiddle::Dimension.order(:id).last
    end

    it { assigns[:dimension].should == last_added }
    it { should redirect_to("/my/dimensions/#{last_added.to_param}") }
    it { should permit_params(:name, :description, :clause, :sortable, :type_code, :visible).for(:dimension) } if Fiddle.strong_parameters?
  end

  describe "GET edit" do
    before do
      get :edit, id: dimension.to_param, use_route: :fiddle
    end

    it { assigns[:dimension].should == dimension }
    it { should respond_with(:success) }
    it { should render_template(:edit) }
  end

  describe "PUT update" do
    before do
      put :update, id: dimension.to_param, use_route: :fiddle,
        dimension: dimension.attributes.slice('name', 'description', 'clause', 'sortable', 'type_code', 'visible')
    end

    it { assigns[:dimension].should == dimension }
    it { should redirect_to("/my/dimensions/#{dimension.to_param}") }
    it { should permit_params(:name, :description, :clause, :sortable, :type_code, :visible).for(:dimension) } if Fiddle.strong_parameters?
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, id: dimension.to_param, use_route: :fiddle
    end

    it { assigns[:dimension].should == dimension }
    it { should redirect_to("/my/cubes/#{cube.to_param}/dimensions") }
  end

end

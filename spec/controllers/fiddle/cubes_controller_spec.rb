require 'spec_helper'

describe Fiddle::CubesController do

  before do
    @routes = Fiddle::Engine.routes
  end

  let :cube do
    create :cube
  end

  let :universe do
    cube.universe
  end

  describe "GET index" do
    before do
      cube # create one
      get :index, universe_id: universe.to_param
    end

    it { expect(assigns(:cubes)).to eq([cube]) }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe "GET show" do
    before do
      get :show, id: cube.to_param
    end

    it { expect(assigns(:cube)).to eq(cube) }
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "GET new" do
    before do
      get :new, universe_id: universe.to_param
    end

    it { expect(assigns(:cube)).to be_present }
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end

  describe "POST create" do
    before do
      post :create, universe_id: universe.to_param, cube: attributes_for(:cube)
    end

    let :last_added do
      Fiddle::Cube.order(:id).last
    end


    it { expect(assigns(:cube)).to eq(last_added) }
    it { should redirect_to("/my/cubes/#{last_added.to_param}") }
    it { should permit_params(:name, :clause).for(:cube) } if Fiddle.strong_parameters?
  end

  describe "GET edit" do
    before do
      get :edit, id: cube.to_param
    end

    it { expect(assigns(:cube)).to eq(cube) }
    it { should respond_with(:success) }
    it { should render_template(:edit) }
  end

  describe "PUT update" do
    before do
      put :update, id: cube.to_param,
        cube: cube.attributes.slice('name', 'clause')
    end

    it { expect(assigns(:cube)).to eq(cube) }
    it { should redirect_to("/my/cubes/#{cube.to_param}") }
    it { should permit_params(:name, :clause).for(:cube) } if Fiddle.strong_parameters?
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, id: cube.to_param
    end

    it { expect(assigns(:cube)).to eq(cube) }
    it { should redirect_to("/my/universes/#{universe.to_param}/cubes") }
  end

end

require 'spec_helper'

describe Fiddle::UniversesController do

  before do
    @routes = Fiddle::Engine.routes
  end

  let :universe do
    create :universe
  end

  describe "GET index" do
    before do
      universe # create one
      get :index
    end

    it { expect(assigns(:universes)).to eq([universe]) }
    it { should respond_with(:success) }
    it { should render_template(:index) }

    describe "response" do
      subject { response.body }
      it { should include('"/my/universes"') }
      it { should include("/my/universes/#{universe.to_param}") }
    end
  end

  describe "GET show" do
    before do
      get :show, id: universe.to_param
    end

    it { expect(assigns(:universe)).to eq(universe) }
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "GET new" do
    before do
      get :new
    end

    it { expect(assigns(:universe)).to be_present }
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end

  describe "POST create" do
    before do
      post :create, universe: attributes_for(:universe)
    end

    let :last_added do
      Fiddle::Universe.order(:id).last
    end

    it { expect(assigns(:universe)).to eq(last_added) }
    it { should redirect_to("/my/universes/#{last_added.to_param}") }
    it { should permit_params(:name, :uri).for(:universe) } if Fiddle.strong_parameters?
  end

  describe "GET edit" do
    before do
      get :edit, id: universe.to_param
    end

    it { expect(assigns(:universe)).to eq(universe) }
    it { should respond_with(:success) }
    it { should render_template(:edit) }
  end

  describe "PUT update" do
    before do
      put :update, id: universe.to_param, universe: universe.attributes.slice('name', 'uri')
    end

    it { expect(assigns(:universe)).to eq(universe) }
    it { should redirect_to("/my/universes/#{universe.to_param}") }
    it { should permit_params(:name, :uri).for(:universe) } if Fiddle.strong_parameters?
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, id: universe.to_param
    end

    it { expect(assigns(:universe)).to eq(universe) }
    it { should redirect_to("/my/universes") }
  end

end

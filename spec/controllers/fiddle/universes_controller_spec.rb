require 'spec_helper'

describe Fiddle::UniversesController do

  let :universe do
    create :universe
  end

  describe "GET index" do
    before do
      universe # create one
      get :index, :use_route => :fiddle
    end

    it { should assign_to(:universes).with([universe]) }
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
      get :show, :id => universe.to_param, :use_route => :fiddle
    end

    it { should assign_to(:universe).with(universe) }
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "GET new" do
    before do
      get :new, :use_route => :fiddle
    end

    it { should assign_to(:universe) }
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end

  describe "POST create" do
    before do
      post :create, :universe => attributes_for(:universe), :use_route => :fiddle
    end

    let :last_added do
      Fiddle::Universe.order(:id).last
    end

    it { should assign_to(:universe).with(last_added) }
    it { should redirect_to("/my/universes/#{last_added.to_param}") }
  end

  describe "GET edit" do
    before do
      get :edit, :id => universe.to_param, :use_route => :fiddle
    end

    it { should assign_to(:universe).with(universe) }
    it { should respond_with(:success) }
    it { should render_template(:edit) }
  end

  describe "PUT update" do
    before do
      put :update, :id => universe.to_param, :universe => {}, :use_route => :fiddle
    end

    it { should assign_to(:universe).with(universe) }
    it { should redirect_to("/my/universes/#{universe.to_param}") }
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, :id => universe.to_param, :use_route => :fiddle
    end

    it { should assign_to(:universe).with(universe) }
    it { should redirect_to("/my/universes") }
  end

end

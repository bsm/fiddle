require 'spec_helper'

describe Fiddle::LookupsController do

  let :lookup do
    create :lookup
  end

  let :universe do
    lookup.universe
  end

  describe "GET index" do
    before do
      lookup # create one
      get :index, :universe_id => universe.to_param, :use_route => :fiddle
    end

    it { should assign_to(:lookups).with([lookup]) }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe "GET show" do
    before do
      get :show, :id => lookup.to_param, :use_route => :fiddle
    end

    it { should assign_to(:lookup).with(lookup) }
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "GET new" do
    before do
      get :new, :universe_id => universe.to_param, :use_route => :fiddle
    end

    it { should assign_to(:lookup) }
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end

  describe "POST create" do
    before do
      attrs = attributes_for :lookup, :universe => nil
      post :create, :universe_id => universe.to_param, :lookup => attrs, :use_route => :fiddle
    end

    let :last_added do
      Fiddle::Lookup.order(:id).last
    end

    it { should assign_to(:lookup).with(last_added) }
    it { should redirect_to("/my/lookups/#{last_added.to_param}") }
  end

  describe "GET edit" do
    before do
      get :edit, :id => lookup.to_param, :use_route => :fiddle
    end

    it { should assign_to(:lookup).with(lookup) }
    it { should respond_with(:success) }
    it { should render_template(:edit) }
  end

  describe "PUT update" do
    before do
      put :update, :id => lookup.to_param, :lookup => {}, :use_route => :fiddle
    end

    it { should assign_to(:lookup).with(lookup) }
    it { should redirect_to("/my/lookups/#{lookup.to_param}") }
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, :id => lookup.to_param, :use_route => :fiddle
    end

    it { should assign_to(:lookup).with(lookup) }
    it { should redirect_to("/my/universes/#{universe.to_param}/lookups") }
  end

end

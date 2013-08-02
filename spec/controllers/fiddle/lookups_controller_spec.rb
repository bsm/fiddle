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
      get :index, universe_id: universe.to_param, use_route: :fiddle
    end

    it { assigns[:lookups].should == [lookup] }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe "GET show" do
    before do
      get :show, id: lookup.to_param, use_route: :fiddle
    end

    it { assigns[:lookup].should == lookup }
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "GET new" do
    before do
      get :new, universe_id: universe.to_param, use_route: :fiddle
    end

    it { assigns[:lookup].should be_present }
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end

  describe "POST create" do
    before do
      attrs = attributes_for :lookup, universe: nil
      attrs.merge! parent_value_clause: 'parent_value'
      post :create, universe_id: universe.to_param, lookup: attrs, use_route: :fiddle
    end

    let :last_added do
      Fiddle::Lookup.order(:id).last
    end

    it { assigns[:lookup].should == last_added }
    it { should redirect_to("/my/lookups/#{last_added.to_param}") }
    it { should permit_params(:name, :clause, :label_clause, :value_clause, :parent_value_clause).for(:lookup) } if Fiddle.strong_parameters?
  end

  describe "GET edit" do
    before do
      get :edit, id: lookup.to_param, use_route: :fiddle
    end

    it { assigns[:lookup].should == lookup }
    it { should respond_with(:success) }
    it { should render_template(:edit) }
  end

  describe "PUT update" do
    before do
      put :update, id: lookup.to_param, use_route: :fiddle,
        lookup: lookup.attributes.slice('name', 'clause', 'label_clause', 'value_clause', 'parent_value_clause')
    end

    it { assigns[:lookup].should == lookup }
    it { should redirect_to("/my/lookups/#{lookup.to_param}") }
    it { should permit_params(:name, :clause, :label_clause, :value_clause, :parent_value_clause).for(:lookup) } if Fiddle.strong_parameters?
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, id: lookup.to_param, use_route: :fiddle
    end

    it { assigns[:lookup].should == lookup }
    it { should redirect_to("/my/universes/#{universe.to_param}/lookups") }
  end

end

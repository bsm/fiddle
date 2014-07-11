require 'spec_helper'

describe Fiddle::RelationsController do

  let :relation do
    create :relation
  end

  let :cube do
    relation.cube
  end

  describe "GET index" do
    before do
      relation # create one
      get :index, cube_id: cube.to_param, use_route: :fiddle
    end

    it { expect(assigns(:relations)).to eq([relation]) }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe "GET show" do
    before do
      get :show, id: relation.to_param, use_route: :fiddle
    end

    it { expect(assigns(:relation)).to eq(relation) }
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "GET new" do
    before do
      get :new, cube_id: cube.to_param, use_route: :fiddle
    end

    it { expect(assigns(:relation)).to be_present }
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end

  describe "POST create" do
    before do
      attrs = attributes_for :relation, cube: nil, predicate: "#{cube.name}.foreign_id = any.id"
      post :create, cube_id: cube.to_param, relation: attrs, use_route: :fiddle
    end

    let :last_added do
      Fiddle::Relation.order(:id).last
    end

    it { expect(assigns(:relation)).to eq(last_added) }
    it { should redirect_to("/my/relations/#{last_added.to_param}") }
    it { should permit_params(:name, :target, :predicate, :operator).for(:relation) } if Fiddle.strong_parameters?
  end

  describe "GET edit" do
    before do
      get :edit, id: relation.to_param, use_route: :fiddle
    end

    it { expect(assigns(:relation)).to eq(relation) }
    it { should respond_with(:success) }
    it { should render_template(:edit) }
  end

  describe "PUT update" do
    before do
      put :update, id: relation.to_param, use_route: :fiddle,
        relation: relation.attributes.slice('name', 'target', 'predicate', 'operator')
    end

    it { expect(assigns(:relation)).to eq(relation) }
    it { should redirect_to("/my/relations/#{relation.to_param}") }
    it { should permit_params(:name, :target, :predicate, :operator).for(:relation) } if Fiddle.strong_parameters?
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, id: relation.to_param, use_route: :fiddle
    end

    it { expect(assigns(:relation)).to eq(relation) }
    it { should redirect_to("/my/cubes/#{cube.to_param}/relations") }
  end

end

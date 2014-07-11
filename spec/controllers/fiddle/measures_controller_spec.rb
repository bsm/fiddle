require 'spec_helper'

describe Fiddle::MeasuresController do

  let :measure do
    create :measure
  end

  let :cube do
    measure.cube
  end

  describe "GET index" do
    before do
      measure # create one
      get :index, cube_id: cube.to_param, use_route: :fiddle
    end

    it { expect(assigns(:measures)).to eq([measure]) }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe "GET show" do
    before do
      get :show, id: measure.to_param, use_route: :fiddle
    end

    it { expect(assigns(:measure)).to eq(measure) }
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "GET new" do
    before do
      get :new, cube_id: cube.to_param, use_route: :fiddle
    end

    it { expect(assigns(:measure)).to be_present }
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end

  describe "POST create" do
    before do
      attrs = attributes_for :measure, cube: nil, clause: "#{cube.name}.some_col"
      attrs.merge! description: 'Some Col Description', sortable: true
      post :create, cube_id: cube.to_param, measure: attrs, use_route: :fiddle
    end

    let :last_added do
      Fiddle::Measure.order(:id).last
    end

    it { expect(assigns(:measure)).to eq(last_added) }
    it { should redirect_to("/my/measures/#{last_added.to_param}") }
    it { should permit_params(:name, :description, :clause, :sortable, :type_code).for(:measure) } if Fiddle.strong_parameters?
  end

  describe "GET edit" do
    before do
      get :edit, id: measure.to_param, use_route: :fiddle
    end

    it { expect(assigns(:measure)).to eq(measure) }
    it { should respond_with(:success) }
    it { should render_template(:edit) }
  end

  describe "PUT update" do
    before do
      put :update, id: measure.to_param, use_route: :fiddle,
        measure: measure.attributes.slice('name', 'description', 'clause', 'sortable', 'type_code')
    end

    it { expect(assigns(:measure)).to eq(measure) }
    it { should redirect_to("/my/measures/#{measure.to_param}") }
    it { should permit_params(:name, :description, :clause, :sortable, :type_code).for(:measure) } if Fiddle.strong_parameters?
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, id: measure.to_param, use_route: :fiddle
    end

    it { expect(assigns(:measure)).to eq(measure) }
    it { should redirect_to("/my/cubes/#{cube.to_param}/measures") }
  end

end

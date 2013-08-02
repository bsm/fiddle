require 'spec_helper'

describe Fiddle::CubesController do

  let :cube do
    create :cube
  end

  let :universe do
    cube.universe
  end

  describe "GET index" do
    before do
      cube # create one
      get :index, :universe_id => universe.to_param, :use_route => :fiddle
    end

    it { assigns[:cubes].should == [cube] }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe "GET show" do
    before do
      get :show, :id => cube.to_param, :use_route => :fiddle
    end

    it { assigns[:cube].should == cube }
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "GET new" do
    before do
      get :new, :universe_id => universe.to_param, :use_route => :fiddle
    end

    it { assigns[:cube].should be_present }
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end

  describe "POST create" do
    before do
      post :create, :universe_id => universe.to_param, :cube => attributes_for(:cube), :use_route => :fiddle
    end

    let :last_added do
      Fiddle::Cube.order(:id).last
    end

    it { assigns[:cube].should == last_added }
    it { should redirect_to("/my/cubes/#{last_added.to_param}") }
  end

  describe "GET edit" do
    before do
      get :edit, :id => cube.to_param, :use_route => :fiddle
    end

    it { assigns[:cube].should == cube }
    it { should respond_with(:success) }
    it { should render_template(:edit) }
  end

  describe "PUT update" do
    before do
      put :update, :id => cube.to_param, :cube => {}, :use_route => :fiddle
    end

    it { assigns[:cube].should == cube }
    it { should redirect_to("/my/cubes/#{cube.to_param}") }
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, :id => cube.to_param, :use_route => :fiddle
    end

    it { assigns[:cube].should == cube }
    it { should redirect_to("/my/universes/#{universe.to_param}/cubes") }
  end

end

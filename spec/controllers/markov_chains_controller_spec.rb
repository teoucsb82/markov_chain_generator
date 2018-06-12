require 'rails_helper'

RSpec.describe MarkovChainsController, type: :contoller do
  describe "GET index" do
    let(:markov_chain) { double(MarkovChain) }
    let(:markov_chains) { [markov_chain, markov_chain] }

    it "assigns @markov_chains" do
      allow(MarkovChain).to receive(:all) { markov_chains }
      get :index
      expect(assigns(:markov_chains)).to eq(markov_chains)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
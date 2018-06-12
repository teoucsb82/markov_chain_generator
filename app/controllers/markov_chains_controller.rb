class MarkovChainsController < ApplicationController
  before_filter :set_markov_chain
  respond_to :html, :json

  def update
    @markov_chain.update_attributes(markov_chain_params)
    respond_with(@markov_chain)
  end

  def show
    respond_with(@markov_chain)
  end

  private
  def markov_chain_params
    params.require(:markov_chain).permit(:text)
  end

  def set_markov_chain
    @markov_chain = MarkovChain.find(params[:id])
  end
end

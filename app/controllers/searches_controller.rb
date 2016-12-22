class SearchesController < ApplicationController
  authorize_resource

  respond_to :html

  def show
    if params[:search]
      @search = Search.new(search_params)
      @search.run
    else
      @search = Search.new
    end
    respond_with(@search)
  end

  private

  def search_params
    params.require(:search).permit(:query, :scope)
  end
end

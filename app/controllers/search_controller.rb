class SearchController < ApplicationController
  def search
    if resource == 'everywhere'
      @search_results = ThinkingSphinx.search params[:query]
    elsif resource
      @search_results = resource.classify.constantize.search params[:query]
    else
      redirect_to root_url
    end
  end

  private

  def resource
    whitelist = %{ everywhere, questions, answers, comments, users }
    whitelist.include?(params[:search_by]) ? params[:search_by] : nil
  end
end

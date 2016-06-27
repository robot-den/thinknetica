class SearchController < ApplicationController
  def search
    if resource == 'everywhere' && !params[:query].empty?
      @search_results = ThinkingSphinx.search ThinkingSphinx::Query.escape(params[:query])
    elsif resource && !params[:query].empty?
      @search_results = resource.classify.constantize.search ThinkingSphinx::Query.escape(params[:query])
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

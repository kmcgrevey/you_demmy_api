class Api::V1::ArticlesController < ApplicationController
  
  def index
    articles = Article.recent
    render json: ArticleSerializer.new(articles)
  end
  
  def show
    article = Article.find(params[:id])
    render json: ArticleSerializer.new(article)
  end

end
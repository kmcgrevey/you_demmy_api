class Api::V1::ArticlesController < ApplicationController
  
  def index
    render json: ArticleSerializer.new(Article.all)
  end
  
  def show
    article = Article.find(params[:id])
    render json: ArticleSerializer.new(article)
  end

end
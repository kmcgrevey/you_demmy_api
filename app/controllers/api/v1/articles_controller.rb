class Api::V1::ArticlesController < ApplicationController
  
  def index
    articles = Article.recent
    paginated = paginator.call(
      articles,
      params: paginator_params,
      base_url: request.url
    )
    options = { meta: paginated.meta.to_h, links: paginated.links.to_h }
    render json: ArticleSerializer.new(paginated.items, options)
  end
  
  def show
    article = Article.find(params[:id])
    render json: ArticleSerializer.new(article)
  end

  def paginator
    JSOM::Pagination::Paginator.new
  end

  def paginator_params
    params.permit![:page]
  end

end
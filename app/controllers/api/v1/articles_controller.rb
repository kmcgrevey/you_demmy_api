class Api::V1::ArticlesController < ApplicationController
  include Paginable
  skip_before_action :authorize!, only: [:index, :show]

  def index
    paginated = paginate(Article.recent)
    render_collection(paginated)
  end
  
  def show
    article = Article.find(params[:id])
    render json: serializer.new(article)
  end

  def create
    article = Article.create(article_params)
    if article.save
      #success
    else
      render json: article, adapter: :json_api,
        serializer: ErrorSerializer,
        status: 422
    end
  end

  def serializer
    ArticleSerializer
  end

  private

  def article_params
    # params[:article].permit(:title, :content)
    ActionController::Parameters.new
  end

end
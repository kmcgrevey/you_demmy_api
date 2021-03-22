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
    # article = Article.create(article_params)
    article = current_user.articles.create(article_params)
    article.save!
    render json: serializer.new(article), status: 201
  rescue
    render json: article, adapter: :json_api,
      serializer: ErrorSerializer,
      status: 422
  end

  def update
    # article = Article.find(params[:id])
    article = current_user.articles.find(params[:id])
    article.update!(article_params)
    render json: serializer.new(article), status: 200
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue
    render json: {}, status: 422
  end

  def serializer
    ArticleSerializer
  end

  private

  def article_params
    params.require(:data).require(:attributes)
      .permit(:title, :content, :slug) ||
    ActionController::Parameters.new
  end

end
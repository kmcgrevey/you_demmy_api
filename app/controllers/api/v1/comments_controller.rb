class Api::V1::CommentsController < ApplicationController
  include Paginable
  skip_before_action :authorize!, only: [:index]
  before_action :load_article
 
  def index
    paginated = paginate(@article.comments)
    render_collection(paginated)
  end

  def create
    comment = @article.comments.create(comment_params.merge(user: current_user))

    if comment.save
      render json: serializer.new(comment), status: :created
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  def serializer
    CommentSerializer
  end

  private

  def load_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :article_id)
  end
end

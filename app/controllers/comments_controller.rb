# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_specialty
  before_action :set_comment, only: [:destroy]
  before_action :authorize_user!, only: [:destroy]

  def create
    @comment = @specialty.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to_comment_success
    else
      respond_to_comment_failure
    end
  end

  def destroy
    @comment.destroy!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("comment_#{@comment.id}") }
      format.html { redirect_to @specialty, success: 'コメントを削除しました' }
    end
  end

  private

  def set_specialty
    @specialty = Specialty.find(params[:specialty_id])
  end

  # specialty にスコープして IDOR を防止
  def set_comment
    @comment = @specialty.comments.find(params[:id])
  end

  def authorize_user!
    redirect_to @specialty, danger: '権限がありません' unless @comment.user == current_user
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def respond_to_comment_success
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @specialty, success: 'コメントを投稿しました' }
    end
  end

  # rubocop:disable Metrics/MethodLength
  def respond_to_comment_failure
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'comment_form',
          partial: 'comments/form',
          locals: { specialty: @specialty, comment: @comment }
        )
      end
      format.html do
        @comments = @specialty.comments.includes(:user).order(created_at: :desc)
        flash.now[:danger] = 'コメントの投稿に失敗しました'
        render 'specialties/show', status: :unprocessable_content
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end

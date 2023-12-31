class Public::CommentsController < ApplicationController
  
  def create
    @post_record = PostRecord.find(params[:post_record_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_record_id = @post_record.id
    @comment.save
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    if @comment.user_id == current_user.id
      @comment.destroy if @comment
    else
      redirect_to post_records_path
      flash[:alert] = "他人のコメントは削除できません。"
    end
  end
  
  private
    def comment_params
      params.require(:comment).permit(:comment)
    end
end

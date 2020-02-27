class BookCommentsController < ApplicationController
	before_action :set_variables

	def create
		book = Book.find(params[:book_id])
		book_comment = current_user.book_comments.new(book_comment_params)
		book_comment.book_id = book.id
		book_comment.save
		# redirect_back(fallback_location: root_path)
	end

	def destroy
		book_comment = current_user.book_comments.find_by(id: params[:comment_id])
		book_comment.destroy
		# redirect_back(fallback_location: root_path)
	end

	private
	def book_comment_params
		params.require(:book_comment).permit(:comment)
	end

	def set_variables
		@book = Book.find(params[:book_id])
		@book.book_comments.all
		@id_name = "#comment-link-#{@book.id}"
	end
end

class SearchController < ApplicationController
	#用途：検索を行う
	def search
		#1=user 2=bookを検索
		if params[:model] == "1"
			@users = search_user(params[:search_method], params[:search])
			if @users.blank?
				@users = User.all
			end

			@book = Book.new
			#redirect_to users_path
			render 'users/index'
		else
			@books = search_book(params[:search_method], params[:search])
			if @books.blank?
				@books = Book.all
			end

			@book = Book.new
			#redirect_to books_path
			render 'books/index'
		end
	end


	private
	# def search_ex(model, search_method, search)
	# 	#1=user 2=bookを検索
	# 	if model == "1"
	# 		search_user(search_method, search)
	# 	else
	# 		search_book(search_method, search)
	# 	end
	# end

	def search_user(search_method, search)
		if search_method == "1"
			User.perfect_matching(search)
		elsif search_method == "2"
			User.forward_match(search)
		elsif search_method == "3"
			User.backward_match(search)
		else
			User.part_match(search)
		end
	end

	def search_book(search_method, search)
		if search_method == "1"
			Book.perfect_matching(search)
		elsif search_method == "2"
			Book.forward_match(search)
		elsif search_method == "3"
			Book.backward_match(search)
		else
			Book.part_match(search)
		end
	end
end

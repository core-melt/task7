class BooksController < ApplicationController

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    #redirect_to books_path, notice: "successfully delete book!"
    redirect_to books_path, notice: "You have deleted book successfully."
  end

  def show
  	@book = Book.find(params[:id])
    #@user = User.find(params[:id])
    @user = User.find(current_user.id)
    #@book_comments = @book.book_comments.all
    @book_comment = @book.book_comments.new
  end

  def index
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @book = Book.new
  end

  def create
  	@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @book.user_id = current_user.id
  	if @book.save #入力されたデータをdbに保存する。
  		#redirect_to @book, notice: "successfully created book!"#保存された場合の移動先を指定。
      redirect_to @book, notice: "You have creatad book successfully."
  	else
  		@books = Book.all
  		render 'index'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
    if @book.user_id != current_user.id
      redirect_to books_path
    end
  end

  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		#redirect_to @book, notice: "successfully updated book!"You have updated book successfully.
      redirect_to @book, notice: "You have updated book successfully."
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render "edit"
  	end
  end



  private

  def book_params
  	params.require(:book).permit(:title, :body)
  end

end

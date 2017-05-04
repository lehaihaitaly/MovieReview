class BooksController < ApplicationController
	before_action :find_book, only: [:show, :update, :destroy, :edit]
	before_action :authenticate_user!, only: [:new, :edit]
	def index
		if params[:category].blank?
		@books = Book.paginate(:page => params[:page], :per_page => 8)
	    else
	    @category_id = Category.find_by(name: params[:category]).id
	    @books = Book.where(:category_id => @category_id).paginate(:page => params[:page], :per_page => 8)

	end
	end

	def show
		if @book.reviews.blank?
			@average_review = 0
		else
			@average_review = @book.reviews.average(:rating).round(2)
	end
 end

	def new
		@book = current_user.books.build
		@categories = Category.all.map{|c| [c.name, c.id]}
	end

	def create
		@book = current_user.books.build(books_params)
		@book.category_id = params[:category_id]
		if @book.save
			flash[:notice] = "Movie created sucesfully!"
			redirect_to root_path
		else
			render 'new'
		end
	end

	def edit
		@categories = Category.all.map{|c| [c.name, c.id]}

	end

	def update
		@book.category_id = params[:category_id]

		if @book.update(books_params)
			flash[:notice] = "Movie updated sucesfully!"
			redirect_to book_path(@book)
		else
			render 'edit'
	end
	end

	def destroy
		@book.destroy
		flash[:notice] = "Movie destroyed sucesfully!"
		redirect_to root_path
	end
	private
	def books_params
		params.require(:book).permit(:title, :description, :author, :category_id, :book_img)
	end

	def find_book
		@book = Book.find(params[:id])
	end
end

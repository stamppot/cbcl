class CodeBooksController < ApplicationController
  
  def index
    @code_books = CodeBook.all
  end

  def show
    @code_book = CodeBook.find(params[:id])
    @view = @code_book.to_hash
  end
end

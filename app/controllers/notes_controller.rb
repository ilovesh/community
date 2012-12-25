class NotesController < ApplicationController
  before_filter :loggedin_user, only: [:new, :create, :destroy]
  before_filter :correct_user,  only: [:edit, :update, :destroy]

  def new
  	@course = Course.find(params[:course_id])
    @note = Note.new
  end

  def create
  	@course = Course.find(params[:course_id])
    @note = @current_user.take_note!(@course, params[:note][:body], params[:note][:title])
    if @note.save
      redirect_to @note
    else
      render 'new'
    end
  end

  def index
    @course = Course.find(params[:course_id])
    @notes = @course.notes.paginate(page: params[:page])
  end

  def show
    @note = Note.find(params[:id])
  end

  def edit
  	@course = @note.course
  end

  def update
    if @note.update_attributes(params[:note])
      flash[:success] = "Note updated"
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
  	@course = @note.course
  	@note.destroy
  	redirect_to @course
  end

private
  def correct_user
    @note = current_user.notes.find_by_id(params[:id])
    redirect_to root_url if @note.nil?
  end  
end
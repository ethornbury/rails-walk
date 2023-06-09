class NotesController < ApplicationController
  #before_action :set_note, only: %i[ show edit update destroy ]
  before_action :authenticate_user! #devise 
  #different user experiences
  #before_action :set_note, only: :show 
  before_action :verify_permission, only: :show  #demands that user logs in
  
  # GET /notes or /notes.json
  def index
    
	if current_user.admin? #check if admin user using own method from app controller
		@notes = Note.all
	else
	  @notes = current_user.notes #restrict to just the notes signed in user created
	end
	
  end
	
  def user_only
    @notes = current_user.notes
  end
  
  # GET /notes/1 or /notes/1.json
  def show
    #addition
	@note = Note.find params[:id]
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to note_url(@note), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to note_url(@note), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy

    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end
	
	def verify_permission
	  redirect_to notes_path if !user_signed_in? || @note.user != current_user
	end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :content, :user_id,)
    end
end

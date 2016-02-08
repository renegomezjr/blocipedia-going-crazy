class CollaboratorsController < ApplicationController

  def index
    @wiki = Wiki.find(params[:wiki_id])
    @collaborators = @wiki.collaborators
  end

  def new
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.new
  end

  def create
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.new(collaborator_params)
    @collaborator.wiki = @wiki

    if @collaborator.save
      flash[:notice] = "You added a collaborator."
    else
      flash[:alert] = "You did not add a collaborator. Try again"
    end
    redirect_to wiki_path(@wiki)

  end

  def destroy
    @collaborator = Collaborator.find(params[:id])

    if @collaborator.destroy
      flash[:notice] = "You removed the collaborator."
    else
      flash[:alert] = "You did not remove the collaborator."
    end
    redirect_to wiki_path(@collaborator.wiki)

  end

  private
  def collaborator_params
    params.require(:collaborator).permit(:user_id, :wiki_id)
  end

end

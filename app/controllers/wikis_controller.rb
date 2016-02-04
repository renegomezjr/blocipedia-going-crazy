class WikisController < ApplicationController
  def index
    @wikis = Wiki.visible_to(current_user)
  end

  def show

    @wiki = Wiki.find(params[:id])

    if @wiki.private? && current_user.standard?
      flash[:notice] = "You must have a Premium Membership to see private wikis."
      redirect_to user_path(current_user)
    end

  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user

    if @wiki.save
      flash[:notice] = "Wiki saved!"
      redirect_to @wiki
    else
      flash[:alert] = "There was an error. Try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)
    authorize @wiki

    if @wiki.save
      flash[:notice] = "Wiki was saved!"
      redirect_to @wiki
    else
      flash[:alert] = "There was an error saving your wiki. Try again."
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted."
      redirect_to wikis_path
    else
      flash[:alert] = "There was an error deleting the wiki. Try again."
      render :show
    end
  end

  private
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end

class Iphone::ProjectsController < ApplicationController
  unloadable
  layout "iphone_blank"

  before_filter :find_project

  def show    
  end

private
  def find_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end

class Iphone::ProjectsController < ApplicationController
  unloadable
  layout "iphone"

  before_filter :find_project

  def show
    cond = @project.project_condition(Setting.display_subprojects_issues?)
    TimeEntry.visible_by(User.current) do
      @total_hours = TimeEntry.sum(:hours, :include => :project, :conditions => cond).to_f
    end
  end

private
  def find_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end

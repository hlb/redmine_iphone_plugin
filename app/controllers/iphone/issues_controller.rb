class Iphone::IssuesController < ApplicationController
  unloadable
  layout "iphone_blank"

  before_filter :find_issue, :only => [:show]
  before_filter :find_project

  def index
    @issues = @project.issues.all(:conditions => [ "tracker_id = ?", params[:tracker_id] ])
  end

  def show
  end

private
  def find_issue
    @issue = Issue.find(params[:id])
  end

  def find_project
    @project = Project.find(params[:project_id]) unless params[:project_id].blank?
    @project = @issue.project if !@project && @issue
  end
end

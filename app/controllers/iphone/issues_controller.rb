class Iphone::IssuesController < ApplicationController
  unloadable
  layout "iphone_blank"

  before_filter :find_issue, :only => [:show]
  before_filter :find_project
  helper :issues
  helper :journals

  def index
    @issues = @project.issues.all(:conditions => [ "tracker_id = ?", params[:tracker_id] ])
  end

  def show
    @journals = @issue.journals.find(:all, :include => [:user, :details], :order => "#{Journal.table_name}.created_on ASC")
    @journals.each_with_index {|j,i| j.indice = i+1}
    @journals.reverse! if User.current.wants_comments_in_reverse_order?
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

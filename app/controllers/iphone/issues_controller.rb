class Iphone::IssuesController < ApplicationController
  unloadable
  layout "iphone"

  before_filter :find_issue, :only => [:show]
  before_filter :find_project
  helper :issues
  helper :journals

  def index
    if params[:tracker_id]
      @tracker = Tracker.find(params[:tracker_id])
      @issues = @project.issues.all(:conditions => [ "tracker_id = ?", params[:tracker_id] ])
    else
      @issues = @project.issues
    end

    @assigned_issues = Issue.visible.open.find(:all,
                                    :conditions => {:assigned_to_id => User.current.id},
                                    :include => [ :status, :project, :tracker, :priority ],
                                    :order => "#{IssuePriority.table_name}.position DESC, #{Issue.table_name}.updated_on DESC")
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

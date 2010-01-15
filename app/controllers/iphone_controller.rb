class IphoneController < ApplicationController
  unloadable

  def index
    @projects = Project.latest User.current
    @assigned_issues = Issue.visible.open.find(:all,
                                    :conditions => {:assigned_to_id => User.current.id},
                                    :include => [ :status, :project, :tracker, :priority ],
                                    :order => "#{IssuePriority.table_name}.position DESC, #{Issue.table_name}.updated_on DESC")
    render :layout => "iphone"
  end
end

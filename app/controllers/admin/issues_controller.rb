class Admin::IssuesController < Admin::BaseController

  before_action { params[:id] && @issue = Issue.find(params[:id]) }

  def index
    @ongoing_issues = Issue.ongoing.ordered.includes(:latest_update, :service_status, :user)
  end

  def resolved
    @issues = Issue.resolved.ordered.includes(:latest_update, :service_status, :user).page(params[:page])
  end

  def show
    @update = @issue.updates.build(:state => @issue.state, :notify => @issue.notify, :estimated_time_to_recovery => @issue.estimated_time_to_recovery, :next_update_at => @issue.next_update_at + 2.hours)
    @updates = @issue.updates.ordered
  end

  def new
    @issue = Issue.new(:state => 'investigating', :notify => true)
  end

  def create
    @issue = Issue.new(safe_params)
    @issue.user = current_user
    if @issue.save
      redirect_to admin_issue_path(@issue), :notice => 'Issue has been added successfully.'
    else
      render 'new'
    end
  end

  def update
    if @issue.update(safe_params)
      redirect_to admin_issue_path(@issue), :notice => 'Issue has been updated successfully.'
    else
      render 'edit'
    end
  end

  def destroy
    @issue.destroy
    redirect_to admin_issues_path, :notice => 'Issue has been removed successfully.'
  end

  private

  def safe_params
    params.require(:issue).permit(:title, :estimated_time_to_recovery, :next_update_at, :initial_update, :state, :service_status_id, :notify, :service_ids => [])
  end

end

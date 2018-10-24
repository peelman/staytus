class Admin::IssueUpdatesController < Admin::BaseController

  before_action { @issue = Issue.find(params[:issue_id]) }
  before_action { params[:id] && @issue_update = @issue.updates.find(params[:id]) }

  def create
    @update = @issue.updates.build(safe_params)
    @update.user = current_user
    if @update.save
      redirect_to admin_issue_path(@issue), :notice => "Update has been posted successfully."
    else
      redirect_to admin_issue_path(@issue), :alert => @update.errors.full_messages.to_sentence
    end
  end

  def update
    if @issue_update.update(safe_params)
      redirect_to admin_issue_path(@issue), :notice => "Update has been updated successfully."
    else
      render 'edit'
    end
  end

  def destroy
    @issue_update.destroy
    redirect_to admin_issue_path(@issue), :notice => "Update has been removed successfully."
  end

  private

  def safe_params
    params.require(:issue_update).permit(:text, :state, :service_status_id, :next_update_at, :estimated_time_to_recovery, :notify)
  end

end

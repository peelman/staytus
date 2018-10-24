class Admin::SlackSettingsController < Admin::BaseController

  def index
    @settings = SlackSetting.pluck(:name)
  end

  def new
    @slack = SlackSetting.new()
  end
  
  def edit
    @default = I18n.translate("slack_settings")[params[:id].to_sym]
    raise Status::Error, "Invalid template name" unless @default.is_a?(Hash)
    @default_content = File.read(Rails.root.join("app", "views", "emails", "#{params[:id]}.txt"))
    @template = EmailTemplate.find_by_name(params[:id])
    @template = EmailTemplate.new(:name => params[:id]) if @template.nil?
  end

  def create
    @slack = SlackSetting.new(safe_params)
    if @slack.save
      redirect_to admin_slack_settings_path(@slack), :notice => 'Issue has been added successfully.'
    else
      render 'new'
    end
  end

  def update
    edit
    @template.attributes = params.require(:email_template).permit(:subject, :content)
    if @template.save
      redirect_to admin_slack_settings_path, :notice => "#{@default[:name]} has been updated successfully."
    else
      render 'edit'
    end
  end

  def destroy
    @template = EmailTemplate.find_by_name!(params[:id])
    @template.destroy
    redirect_to admin_email_templates_path, :notice => "Template has been reverted successfully."
  end

  private

  def safe_params
    params.require(:slack_setting).permit(:webhook_url)
  end

end

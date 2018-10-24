# == Schema Information
#
# Table name: slack_settings
#
#  id          :integer          not null, primary key
#  webhook_url :string(255)
#  icon        :string(255)
#  channel     :string(255)
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SlackSetting < ActiveRecord::Base

  validates :webhook_url, :presence => true
  validates :channel, :presence => true
  validates :username, :presence => true # TODO validate pattern (@username or #channel)
  validates :icon, :presence => true # TODO validate pattern (:icon:)

  def self.body_for(name)
    if template = self.where(:name =>name).select(:content).first
      template.content
    end
  end

  def self.subject_for(name)
    if template = self.where(:name =>name).select(:subject).first
      template.subject
    end
  end

end

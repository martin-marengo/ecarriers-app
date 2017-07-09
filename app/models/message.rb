class Message < ActiveRecord::Base
  belongs_to :person, polymorphic: true
  belongs_to :conversation

  validates :body, :person, :conversation, presence: true

  def created_time
    created_at.localtime.strftime('%d/%m/%Y - %H:%M')
  end
end
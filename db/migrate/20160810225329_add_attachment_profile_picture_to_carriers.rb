class AddAttachmentProfilePictureToCarriers < ActiveRecord::Migration
  def self.up
    change_table :carriers do |t|
      t.attachment :profile_picture
    end
  end

  def self.down
    remove_attachment :carriers, :profile_picture
  end
end

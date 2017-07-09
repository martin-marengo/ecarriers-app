class Carrier < ActiveRecord::Base
  include MailValidation
  has_many :shipment_publications
  has_many :bids, dependent: :destroy
  has_many :messages, as: :person

  belongs_to :address
  accepts_nested_attributes_for :address, allow_destroy: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable,
         :lockable, :timeoutable
  
  validate :uniqueness_of_email
  validates :business_name, :phone_number, :company_description, :address, presence: true

  has_attached_file :profile_picture, styles: { thumb: '75x75>', small: '"150x150>', chat: '50x50>' }

  validates_attachment_content_type :profile_picture, content_type: %w(image/jpg image/jpeg image/png)
  validates_attachment_size :profile_picture, less_than: 6.megabytes

  # Funcionalidad checkbox de borrar imagen en edicion de datos
  before_validation { profile_picture.clear if @delete_profile_picture }
  
  def delete_profile_picture
    @delete_profile_picture ||= false
  end
  
  def delete_profile_picture=(value)
    @delete_profile_picture  = !value.to_i.zero?
  end
  # fin checkbox

  def has_api_token?
    !api_token.blank?
  end

end

# Addition options to has_attached_file (not nessesary now cos we use AWS S3 to storage)
# url: '/assets/carriers/:id/:style/:basename.:extension', path: ':rails_root/public/assets/carriers/:id/:style/:basename.:extension'

# Pare creacion de carriers con address en devise
# http://stackoverflow.com/questions/2615268/multiple-children-in-single-form-in-rails
# http://stackoverflow.com/questions/17767449/rails-4-0-with-devise-nested-attributes-unpermited-parameters
# http://stackoverflow.com/questions/16368750/adding-nested-attributes-to-devise-user-model
# http://stackoverflow.com/questions/16442541/user-address-association-in-rails


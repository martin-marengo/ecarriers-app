# Preview all emails at http://localhost:3000/rails/mailers/shipment_publication_notifier
class ShipmentPublicationNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/shipment_publication_notifier/published
  def published
    ShipmentPublicationMailer.published
  end

end

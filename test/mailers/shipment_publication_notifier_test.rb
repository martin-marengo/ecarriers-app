require 'test_helper'

class ShipmentPublicationNotifierTest < ActionMailer::TestCase
  
  test "published" do
    shipment_publication = shipment_publications(:one)
    user = users(:cacho_castaña)
    
    mail = ShipmentPublicationMailer.published shipment_publication, user
    
    assert_equal 'eCarriers - ¡Envío publicado!', mail.subject
    assert_equal [user.email], mail.to
  end
  
  

end

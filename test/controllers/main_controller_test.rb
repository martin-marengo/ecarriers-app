require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "Can create controller" do
    controller = MainController.new
    
    assert_not_nil controller
  end
end

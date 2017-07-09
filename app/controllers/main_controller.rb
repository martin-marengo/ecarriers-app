class MainController < ApplicationController

  after_action :clear_flash_messages, only: [ :index ]

  # Root, home
  def index
    render :index, layout: 'main_page_layout'
  end

  private

  # Al cerrar sesion (por ejemplo) devise setea un flash y hace un redirect a home.
  # Si despues vamos a login por ejemplo, se sigue mostrando ese flash.
  def clear_flash_messages
    flash.clear
  end

end
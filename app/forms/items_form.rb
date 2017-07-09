class ItemsForm < AbstractForm
  
  def get_items
    items = []
    
    @params.each do |item_data|
      items << Item.new(
        name: item_data[:name],
        length_m: item_data[:length_m],
        length_cm: item_data[:length_cm],
        width_m: item_data[:width_m],
        width_cm: item_data[:width_cm],
        height_m: item_data[:height_m],
        height_cm: item_data[:height_cm],
        weight_kg: item_data[:weight_kg],
        quantity: item_data[:quantity]
      )
    end
    
    return items
  end
end
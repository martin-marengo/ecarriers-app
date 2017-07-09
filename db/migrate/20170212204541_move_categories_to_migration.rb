class MoveCategoriesToMigration < ActiveRecord::Migration
  def up
    # Parent categories
    boats_and_vehicles = Category.new(name: 'Vehículos y barcos', description: 'Automóviles, Motos, Remolques, Partes de Vehículos', code_name: 'boats_and_vehicles')
    household_items = Category.new(name: 'Artículos domésticos', description: 'Muebles, Electrodomésticos', code_name: 'household_items')
    moves = Category.new(name: 'Mudanzas', description: 'Departamento, casa, oficina', code_name: 'moves')
    heavy_equipment = Category.new(name: 'Maquinaria pesada', description: 'Construcción, Agricultura', code_name: 'heavy_equipment')
    freight = Category.new(name: 'Flete', description: 'Tarima con artículos, Carga completa.', code_name: 'freight')
    animals = Category.new(name: 'Animales', description: 'Perros, Gatos, Ganado', code_name: 'animals')
  
    boats_and_vehicles.save!
    household_items.save!
    moves.save!
    heavy_equipment.save!
    freight.save!
    animals.save!

    # Boats and vehicles children
    car_and_light_trucks = Category.new(name: 'Automóviles y Camiones ligeros', description: 'Test', code_name: 'car_and_light_trucks')
    motorcycles_and_mopeds = Category.new(name: 'Motocicletas y Ciclomotores', description: 'Test', code_name: 'motorcycles_and_mopeds')
    powerboats = Category.new(name: 'Botes de motor', description: 'Test', code_name: 'powerboats')
    sailboats = Category.new(name: 'Veleros', description: 'Test', code_name: 'sailboats')
    personal_watercrafts = Category.new(name: 'Motos acuáticas y otros botes', description: 'Test', code_name: 'personal_watercrafts')
    recreational_vehicles = Category.new(name: 'Casa rodante', description: 'Test', code_name: 'recreational_vehicles')
    atvs_and_power_sports = Category.new(name: 'Vehículos todo terreno', description: 'Test', code_name: 'atvs_and_power_sports')
    commercial_trucks = Category.new(name: 'Camiones comerciales', description: 'Test', code_name: 'commercial_trucks')
    farm_equipment = Category.new(name: 'Maquinaria agrícola', description: 'Test', code_name: 'farm_equipment')
    construction_equipment = Category.new(name: 'Maquinaria de construcción', description: 'Test', code_name: 'construction_equipment')
    trailer = Category.new(name: 'Remolques', description: 'Test', code_name: 'trailer')
    another_vehicle = Category.new(name: 'Otro tipo de vehículos', description: 'Test', code_name: 'another_vehicle')
  
    car_and_light_trucks.parent_category = boats_and_vehicles
    motorcycles_and_mopeds.parent_category = boats_and_vehicles
    powerboats.parent_category = boats_and_vehicles
    sailboats.parent_category = boats_and_vehicles
    personal_watercrafts.parent_category = boats_and_vehicles
    recreational_vehicles.parent_category = boats_and_vehicles
    atvs_and_power_sports.parent_category = boats_and_vehicles
    commercial_trucks.parent_category = boats_and_vehicles
    farm_equipment.parent_category = boats_and_vehicles
    construction_equipment.parent_category = boats_and_vehicles
    trailer.parent_category = boats_and_vehicles
    another_vehicle.parent_category = boats_and_vehicles
  
    car_and_light_trucks.save!
    motorcycles_and_mopeds.save!
    powerboats.save!
    sailboats.save!
    personal_watercrafts.save!
    recreational_vehicles.save!
    atvs_and_power_sports.save!
    commercial_trucks.save!
    farm_equipment.save!
    construction_equipment.save!
    trailer.save!
    another_vehicle.save!

    # Household items children
    furniture = Category.new(name: 'Muebles', description: 'Test', code_name: 'furniture')
    appliances = Category.new(name: 'Electrodomésticos', description: 'Test', code_name: 'appliances')
    home_electronics = Category.new(name: 'Aparatos electrónicos', description: 'Test', code_name: 'home_electronics')
    outdoor_equipment = Category.new(name: 'Equipamiento de aire libre', description: 'Test', code_name: 'outdoor_equipment')
    sporting_equipment = Category.new(name: 'Equipamiento deportivo', description: 'Test', code_name: 'sporting_equipment')
    antiques = Category.new(name: 'Antigüedades', description: 'Test', code_name: 'antiques')
    art_and_glass = Category.new(name: 'Artes y vidrios', description: 'Test', code_name: 'art_and_glass')
    pianos = Category.new(name: 'Pianos', description: 'Test', code_name: 'pianos')
    pool_tables = Category.new(name: 'Mesa de billar', description: 'Test', code_name: 'pool_tables')
  
    furniture.parent_category = household_items
    appliances.parent_category = household_items
    home_electronics.parent_category = household_items
    outdoor_equipment.parent_category = household_items
    sporting_equipment.parent_category = household_items
    antiques.parent_category = household_items
    art_and_glass.parent_category = household_items
    pianos.parent_category = household_items
    pool_tables.parent_category = household_items
  
    furniture.save!
    appliances.save!
    home_electronics.save!
    outdoor_equipment.save!
    sporting_equipment.save!
    antiques.save!
    art_and_glass.save!
    pianos.save!
    pool_tables.save!

    # Moves children
    small_studio = Category.new(name: 'Estudio pequeño', description: 'Test', code_name: 'small_studio')
    house = Category.new(name: 'Casa', description: 'Test', code_name: 'house')
    low_level_flat = Category.new(name: 'Departamento en planta baja', description: 'Test', code_name: 'low_level_flat')
    upper_level_flat = Category.new(name: 'Departamento en piso superior', description: 'Test', code_name: 'upper_level_flat')
  
    small_studio.parent_category = moves
    low_level_flat.parent_category = moves
    upper_level_flat.parent_category = moves
    house.parent_category = moves
  
    small_studio.save!
    house.save!
    low_level_flat.save!
    upper_level_flat.save!

    # Freight children
    platform_with_new_articles = Category.new(name: 'Tarimas de artículos nuevos', description: 'Test', code_name: 'platform_with_new_articles')
    platform_with_old_articles = Category.new(name: 'Tarimas de artículos usados', description: 'Test', code_name: 'platform_with_old_articles')
    complete_cargo = Category.new(name: 'Carga completa', description: 'Test', code_name: 'complete_cargo')
  
    platform_with_new_articles.parent_category = freight
    platform_with_old_articles.parent_category = freight
    complete_cargo.parent_category = freight
  
    platform_with_new_articles.save!
    platform_with_old_articles.save!
    complete_cargo.save!

    # Animals children
    dogs = Category.new(name: 'Perros', description: 'Test', code_name: 'dogs')
    cats = Category.new(name: 'Gatos', description: 'Test', code_name: 'cats')
    horses = Category.new(name: 'Caballos', description: 'Test', code_name: 'horses')
    cattle = Category.new(name: 'Ganado', description: 'Test', code_name: 'cattle')
    another_animal = Category.new(name: 'Otros tipos de animales', description: 'Test', code_name: 'another_animal')
  
    dogs.parent_category = animals
    cats.parent_category = animals
    horses.parent_category = animals
    cattle.parent_category = animals
    another_animal.parent_category = animals
  
    dogs.save!
    cats.save!
    horses.save!
    cattle.save!
    another_animal.save!
  end
  
  def down
    Category.delete_all
  end
end

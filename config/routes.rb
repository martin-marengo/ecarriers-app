Rails.application.routes.draw do
  apipie
  
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
  
  draw :api
  draw :shared
  draw :carrier
  draw :seller
  draw :user
end

Rails.application.routes.draw do
  root 'top#show' 
  post 'mortor/control'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

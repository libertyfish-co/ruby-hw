Rails.application.routes.draw do
  root 'top#show'
  get 'mortor/forward'
  get 'mortor/left'
  get 'mortor/right'
  get 'mortor/back'
  get 'mortor/breake'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

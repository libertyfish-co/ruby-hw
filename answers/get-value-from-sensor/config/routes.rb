Rails.application.routes.draw do
  get 'leds/on'
  get 'leds/off'
  get 'top/show'
  root 'top#show'
end

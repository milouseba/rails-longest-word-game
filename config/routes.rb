Rails.application.routes.draw do
  get 'ask', to: 'play_game#ask'


  get 'result', to: 'play_game#result'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

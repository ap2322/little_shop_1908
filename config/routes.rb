Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  get "/items/:item_id/reviews/:review_id/edit", to: "reviews#edit"
  get "/items/:item_id/reviews/sort_rating", to: "items#sort_rating"
  patch "/items/:item_id/reviews/:review_id", to: "reviews#update"
  post "/items/:item_id/reviews", to: "reviews#create"
  delete "/items/:item_id/reviews/:review_id", to: "reviews#destroy"

  get "/cart", to: "cart#show"
  patch "/cart/:item_id", to: "cart#update_cart"
  delete "/cart/empty", to: "cart#empty"
  delete "/cart/remove_item/:item_id", to: "cart#remove_item"
  patch "/cart/increment_item/:item_id", to: "cart#increment_item"
  patch "/cart/decrement_item/:item_id", to: "cart#decrement_item"

  get "/orders/new", to: "orders#new"
  get "/orders/:order_id", to: "orders#show"
  post "/orders", to: "orders#create"
end

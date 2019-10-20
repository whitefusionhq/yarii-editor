YariiEditor::Engine.routes.draw do
  get 'documents/:content_model', to: 'documents#index', as: 'documents'
  post 'documents/:content_model', to: 'documents#create', as: 'create_document'
  get 'documents/:content_model/new', to: 'documents#new', as: 'new_document'
  get 'documents/:content_model/:id/edit', to: 'documents#edit', as: 'edit_document' 
  put 'documents/:content_model/:id', to: 'documents#update', as: 'update_document'
  delete 'documents/:content_model/:id', to: 'documents#destroy', as: 'destroy_document'

  get 'publish/menu', to: 'publish#menu', as: 'publishing_menu'

  root to: "dashboard#index"
end

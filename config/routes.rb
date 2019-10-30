YariiEditor::Engine.routes.draw do
  get 'documents/:content_model', to: 'documents#index', as: 'documents'
  post 'documents/:content_model', to: 'documents#create', as: 'create_document'
  get 'documents/:content_model/new', to: 'documents#new', as: 'new_document'
  get 'documents/:content_model/:id/edit', to: 'documents#edit', as: 'edit_document' 
  put 'documents/:content_model/:id', to: 'documents#update', as: 'update_document'
  delete 'documents/:content_model/:id', to: 'documents#destroy', as: 'destroy_document'

  get 'publish/remote_is_up_to_date', to: 'publish#remote_is_up_to_date', as: 'remote_is_up_to_date'
  get 'publish/menu', to: 'publish#menu', as: 'publishing_menu'
  get 'publish/commit', to: 'publish#commit', as: 'commit_publish'
  post 'publish/push_commit', to: 'publish#push_commit', as: 'push_commit_publish'

  get 'dashboard/list', to: 'dashboard#list', as: 'dashboard_list'
  root to: "dashboard#index"
end

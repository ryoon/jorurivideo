JoruriVideo::Application.routes.draw do
  mod = "video"
  scp = "admin"

  scope "_#{scp}" do
    namespace mod do
      scope :module => scp do
        resources :clips do
          member do
              get :preview
              get :download
              get :negate
          end
        end
        resources :my_clips, :controller  => "clips/mine" do
          member do
              get :preview
              get :download
              get :pre_download
          end
        end
        resources :shared_clips, :controller  => "clips/shared" do
          member do
              get :preview
              get :download
              get :pre_download
          end
        end
        resources :all_clips, :controller  => "clips/all" do
          member do
              get :preview
              get :download
              get :pre_download
              get :negate
          end
        end
        resources :categories
        resources :settings
        resources :admin_menus
        resources :skins
        resources :messages
        resources :admin_settings
        resources :posting_files do
          member do
            get :thumbnail
          end
        end
        match "clip_files/:tmp_id/pre_download" => "clips/mine#pre_download"
      end
    end
  end

  ## public
  match "/_public/#{mod}/clips/:id/:checkdigit/show/"     => "#{mod}/public/clips#show"
  match "/_public/#{mod}/clips/:id/:checkdigit/download.:format" => "#{mod}/public/clips#download"
  match "/_public/#{mod}/clips/:id/:checkdigit/thumbnail/" => "#{mod}/public/clips#thumbnail"

end

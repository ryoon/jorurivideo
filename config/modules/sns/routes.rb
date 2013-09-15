JoruriVideo::Application.routes.draw do
  mod = "sns"
  scp = "admin"

  scope "_#{scp}" do
    namespace mod do
      scope :module => scp do
        resources :profiles
        resources :profile_configs
        resources :profile_photos do
          get 'select', :on => :member
        end
        resources :profile_photo_selects
        resources :tests
        resources :posts
        #resources :posts do
        #  resources :comments#comments の親がpostsになる
        #end
      end
    end
  end

end

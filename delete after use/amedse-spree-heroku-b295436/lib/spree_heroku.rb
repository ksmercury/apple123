require 'spree_core'
require 'spree_heroku_hooks'

module SpreeHeroku
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      
      # Disable caching in the production environment
      ActionController::Base.perform_caching = false if Rails.env == 'production'
      
      Spree::FileUtilz.class_eval do
        class << self
          # Patch mirror_files method to be silent when using r/o Heroku FS
          alias_method :mirror_files_old, :mirror_files
          def mirror_files(source, destination, create_backups = false)
            return mirror_files_old(source, destination, create_backups) unless Rails.env == 'production'
            mirror_files_old(source, destination, create_backups) rescue true
          end
        end
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end

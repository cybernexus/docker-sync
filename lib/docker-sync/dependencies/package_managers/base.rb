module DockerSync
  module Dependencies
    module PackageManager
      class Base
        DID_NOT_INSTALL_PACKAGE   = 'Did not install required package. Please install it manually and try again.'.freeze
        FAILED_TO_INSTALL_PACKAGE = 'Failed to install required package. Please install it manually and try again.'.freeze

        extend Forwardable
        def_delegators :"Thor::Shell::Color.new", :say_status, :yes?

        attr_reader :package

        def self.install_package(*args)
          ensure!
          new(*args).send(:install_package)
        end

        def initialize(package)
          @package = package
        end

        private

        def install_package
          say_status 'warning', "Could not find #{package}. Trying to install it now.", :yellow
          ask_user_confirmation
          say_status 'command', install_cmd, :white
          raise(FAILED_TO_INSTALL_PACKAGE) unless system(install_cmd)
        end

        def ask_user_confirmation
          raise(DID_NOT_INSTALL_PACKAGE) unless yes?("Install #{package} for you? [y/N]")
        end

        def install_cmd
          raise NotImplementedError
        end
      end
    end
  end
end

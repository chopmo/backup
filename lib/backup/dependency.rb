# encoding: utf-8

module Backup

  ##
  # A little self-contained gem manager for Backup.
  # Rather than specifying hard dependencies in the gemspec, forcing users
  # to install gems they do not want/need, Backup will notify them when a gem
  # has not been installed, or when the gem's version is incorrect, and provide the
  # command to install the gem. These dependencies are dynamically loaded in the Gemfile
  class Dependency
    extend Backup::CLI

    ##
    # Returns a hash of dependencies that Backup requires
    # in order to run every available feature
    def self.all
      {
        'fog' => {
          :require => 'fog',
          :version => '>= 0.11.0',
          :for     => 'Amazon S3, Rackspace Cloud Files (S3, CloudFiles Storages)'
        },

        'dropbox' => {
          :require => 'dropbox',
          :version => '~> 1.3.0',
          :for     => 'Dropbox Web Service (Dropbox Storage)'
        },

        'net-sftp' => {
          :require => 'net/sftp',
          :version => '~> 2.0.5',
          :for     => 'SFTP Protocol (SFTP Storage)'
        },

        'net-scp' => {
          :require => 'net/scp',
          :version => '~> 1.0.4',
          :for     => 'SCP Protocol (SCP Storage)'
        },

        'net-ssh' => {
          :require => 'net/ssh',
          :version => '~> 2.1.4',
          :for     => 'SSH Protocol (SSH Storage)'
        },

        'mail' => {
          :require => 'mail',
          :version => '>= 2.2.15',
          :for     => 'Sending Emails (Mail Notifier)'
        },

        'twitter' => {
          :require => 'twitter',
          :version => '>= 1.7.1',
          :for     => 'Sending Twitter Updates (Twitter Notifier)'
        },

        'httparty' => {
          :require => 'httparty',
          :version => '~> 0.7.4',
          :for     => 'Sending Http Updates'
        },

        'json' => {
          :require => 'json',
          :version => '~> 1.5.1',
          :for     => 'Parsing JSON for HTTParty'
        },
        
        'prowler' => {
          :require => 'prowler',
          :version => '>= 1.3.1',
          :for     => 'Sending iOS push notifications (Prowl Notifier)'
        },
        
      }
    end

    ##
    # Attempts to load the specified gem (by name and version).
    # If the gem with the correct version cannot be found, it'll display a message
    # to the user with instructions on how to install the required gem
    def self.load(name)
      begin
        gem(name, all[name][:version])
        require(all[name][:require])
      rescue LoadError
        Backup::Logger.error("Dependency missing.")
        puts "\nDependency required for:"
        puts "\n\s\s#{all[name][:for]}"
        puts "\nTo install the gem, issue the following command:"
        puts "\n\s\sgem install #{name} -v '#{all[name][:version]}'"
        puts "\nPlease try again after installing the missing dependency."
        exit
      end
    end

  end
end

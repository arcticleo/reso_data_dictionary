module ResoDataDictionary
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("../templates", __FILE__)

      desc "Copy RESO Data Dictionary migration files to your application."


      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S%L")
      end

      def create_model_file
        template "enumerals.csv", "db/enumerals.csv"
        %w[addresses 
           businesses 
           enumerals 
           expenses 
           imports
           listings
           listing_media 
           listing_providers 
           mls
           open_houses
           offices
           people
           participants 
           participant_licenses 
           places
           prices
           queued_listings
           rooms
           schools
           taxes
           join_tables].each do |name|
             migration_template "create_#{name}.rb", "db/migrate/create_#{name}.rb"
           end
      end

    end
  end
end
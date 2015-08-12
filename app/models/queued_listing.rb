class QueuedListing < ActiveRecord::Base
  belongs_to :import
  serialize :listing_data
  after_save :create_listing_and_remove_myself

  def mapper
    "Mapper::#{self.import.import_format.name.downcase.capitalize}".constantize
  end

  def create_or_update_listing
    listing = self.import.listings.find_or_initialize_by(
      listing_key: mapper.unique_identifier(self)
    )
    if (listing.modification_timestamp != mapper.modification_timestamp(self, listing))
      Mapper::RESO_LISTING_ATTRIBUTES.each do |attribute|
        listing.send("#{attribute}=", mapper.send(attribute, self, listing))
      end
      listing.save
    end
  end

  def create_listing_and_remove_myself
    create_or_update_listing ? self.destroy : false 
  end
  
end

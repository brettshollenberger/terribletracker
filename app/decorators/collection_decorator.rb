class Draper::CollectionDecorator

    delegate :current_page, :per_page, :offset, :total_entries, :total_pages

    def total_count
      source.total_count
    end

end



class BaseMongoid  		

    def self.set_collection_index(index)
      @collection_index = index % 1000
    end

  	def self.super_get(condition, filter = [])
      where(condition).only(filter).first
  	end

    def self.set_attributes(condition, params)
      params.each do |key, value|
        if key.to_s.include?('.')
          find_or_create_by(condition).update_attribute(key, value)
          params.delete(key)
        end
      end
      find_or_create_by(condition).update_attributes(params) unless params.empty? 
    end

  	def self.super_push(condition, array_name, push_values)
  		find_or_create_by(condition).add_to_set({array_name => push_values})
  	end

  	def self.super_pop(condition, array_name, pop_option = 1)
  		where(condition).pop(array_name => pop_option)
  	end

    def self.sanitize_params(params, valid_params)
    params.symbolize_keys.delete_if {|key, value| !(valid_params.include?(key) || key.to_s.include?('.')) }
  end
end
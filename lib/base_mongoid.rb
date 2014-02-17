class BaseMongoid  		

    def self.set_collection_index(index)
      @collection_index = index.to_i % 1000
    end

  	def self.super_get(condition, filter = [])
      where(condition).only(filter).first
  	end

    def self.super_set_element(condition, array_name, array_index_value)
      params = {}
      array_index_value.each do |arr|
        params["#{array_name}.#{arr[0]}"] = arr[1]
      end
      binding.pry
      Tags.where(condition).set(params) 
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
      record = nil
      retval =0;
      if pop_option == 1
        record = super_slice(condition, array_name, 0)
      else
        record = super_slice(condition, array_name, -1)
      end
      retval = record[array_name.to_sym][0]
      where(condition).pop(array_name => pop_option)
      retval
  	end

    def self.super_slice(condition, array_name, offset, limit = 1)
      where(condition).slice(array_name => [offset, limit]).first
    end

    def self.super_delete(condition)
      where(condition).delete
    end

    def self.sanitize_params(params, valid_params)
      params.symbolize_keys.delete_if {|key, value| !(valid_params.include?(key) || key.to_s.include?('.')) }
    end
end
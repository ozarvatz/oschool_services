class Users < BaseMongoid
	include Mongoid::Document
	include Mongoid::Timestamps

	store_in  session: ->{ "cluster_users" }, collection: ->{ generate_collection }

	field :user_id,              type: Integer
	field :type,				 type: String,     default: "candidate"
	field :search_strings,       type: Array,      default: []
	field :tags,				 type: Hash,       default: {}
	field :city,	     		 type: String
	field :phone,				 type: String
	field :email,				 type: String

	index({ user_id: 1 }, { unique: true, name: "users_index" })

	# alias :supper_push :push
	# alias :supper_pop  :pop
	# alias :supper_get  :get

	def self.generate_collection
  		"user_data_#{@collection_index}"
  	end

	def self.get(user_id, filter = [])
		set_collection_index(user_id)
		self.super_get({user_id: user_id}, filter)	
	end

	def self.set(user_id, params)
		set_collection_index(user_id)
		params = sanitize_params(params, self.fields.symbolize_keys.keys)
		self.set_attributes({user_id: user_id}, params) 	 
	end

	def self.push(user_id, params)
		set_collection_index(user_id)
		params = sanitize_params(params, self.fields.symbolize_keys.keys)
		params.each do |key, value|
			if self.fields[key.to_s].options[:type] == (Array)
				self.super_push({user_id: user_id}, key, value)
			end
		end
	end

	def self.pop(user_id, array_name, pop_option = 1)
		set_collection_index(user_id)
		self.super_pop({user_id: user_id}, array_name, pop_option)
	end

	def self.delete(user_id)
		set_collection_index(user_id)
		self.super_delete({user_id: user_id})
	end
end
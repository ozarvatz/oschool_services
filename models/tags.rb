class Tags < BaseMongoid
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in  session: ->{ "cluster_tags" }, collection: ->{ "tags" }

  field :tag,          type: String
  field :users,  	     type: Array,      default: []
  field :flags,			   type: Hash,		   default: {}


  index({ tag: 1 }, { unique: true, name: "tags_index" })

  def self.push(tag_name, params)
    params = sanitize_params(params, self.fields.symbolize_keys.keys)
    params.each do |key, value|
      if self.fields[key.to_s] && self.fields[key.to_s].options[:type] == (Array)
        self.super_push({tag: tag_name}, key, value)
      end
    end
  end

  def self.get(tag_name, filter = [:users])
    res = self.super_get({tag: tag_name}, filter)
  end

  def self.set(tag_name, params)
    params = sanitize_params(params, self.fields.symbolize_keys.keys)
    self.set_attributes({tag: tag_name}, params)    
  end

  def self.slice(tag_name, params)
    params = sanitize_params(params, self.fields.symbolize_keys.keys)
    params.each do |key, value|
      if self.fields[key.to_s] && self.fields[key.to_s].options[:type] == (Array)
        return self.super_slice({tag: tag_name}, key, value[0], value[1] || 1)
      end
    end
  end

  def self.set_element(tag_name, params)
    params = sanitize_params(params, self.fields.symbolize_keys.keys)
    params.each do |key, value|
      if self.fields[key.to_s] && self.fields[key.to_s].options[:type] == (Array)
        return self.super_set_element({tag: tag_name}, key, value) if value.kind_of?(Array)
      end
    end
  end

end
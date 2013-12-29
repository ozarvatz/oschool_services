module SporaServiceApi
	class TagsApi < Grape::API
		get '/' do
			{ status: 200 , all: Tags.all}
		end
		
		get ':name' do
			{ status: 200, users: Tags.get(params[:name], []) }
		end

		get ':name/users' do
			{ status: 200, users: Tags.get(params[:name], [:users]) }
		end

		get ':name/flags' do
			{ status: 200, users: Tags.get(params[:name], [:flags]) }			
		end

		put ':name/push' do
			binding.pry
			tag_name = params.delete(:name)
			return { status: 501, error: "params hash is empty!!!" } if params.empty?
			Tags.push(tag_name, params)
			{ status: 200 }
		end

		put ':name' do
			tag_name = params.delete(:name)
			return { status: 501, error: "params hash is empty!!!" } if params.empty?
			Tags.set(tag_name, params)
			{ status: 200 }
		end
	end
end
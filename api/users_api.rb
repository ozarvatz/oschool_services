module SporaServiceApi
	class UsersApi < Grape::API
		
		get ':id' do
			{ status: 200, user: Users.get(params[:id]) }
		end

		put ':id' do
			user_id = params[:id]
			return { status: 501, error: "there is not user_id value at the params" } unless user_id
			Users.set(user_id, params)
			{ status: 200 }
		end

		put ':id/push' do
			user_id = params.delete(:id)
			return { status: 501, error: "there are missing values at the params hash" } if user_id.nil? || params.empty?
			{ status: 200, ret: Users.push(user_id, params) }
		end

		post ':id/pop' do
			user_id = params.delete(:id)
			return { status: 501, error: "there are missing values at the params" } unless params[:array_name]
			pop_option = (params[:pop_option] || 1).to_i
			{ status: 200, ret: Users.pop(user_id, params[:array_name], pop_option) }
		end
	end
end
# frozen_string_literal: true
module Users
  class RegistrationsController < Devise::RegistrationsController
    
    # before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]
    include RackSessionsFix

    respond_to :json

    # def create
    #   build_resource(sign_up_params)

    #   resource.save
    #   yield resource if block_given?
    #   if resource.persisted?
    #     if resource.active_for_authentication?
    #       sign_up(resource_name, resource)
    #       respond_with resource, location: after_sign_up_path_for(resource)
    #     else
    #       expire_data_after_sign_in!
    #       respond_with resource, location: after_inactive_sign_up_path_for(resource)
    #     end
    #   else
    #     clean_up_passwords resource
    #     set_minimum_password_length
    #     respond_with resource
    #   end
    # end

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        render json: {
          status: {code: 200, message: "Signed up sucessfully."},
          data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }, status: :ok
      elsif request.method == "DELETE"
        render json: {
          status: { code: 200, message: "Account deleted successfully."}
        }, status: :ok
      else
        render json: {
          status: {code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
        }, status: :unprocessable_entity
      end
    end
  end
end

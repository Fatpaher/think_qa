class Api::V1::ProfilesController < Api::V1::ApiController
  authorize_resource :user
  def index
    respond_with User.where.not(id: current_resource_owner)
  end

  def me
    respond_with current_resource_owner
  end
end

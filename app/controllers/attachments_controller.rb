class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    attachable = @attachment.attachable_type.constantize.find(@attachment.attachable_id)
    @attachment.destroy if current_user.id == attachable.user_id
  end

end

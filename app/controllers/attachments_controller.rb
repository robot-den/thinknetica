class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_attachment, only: :destroy

  respond_to :js

  def destroy
    @attachment.destroy if current_user.id == @attachment.attachable.user_id
    respond_with @attachment
  end

  private

  def get_attachment
    @attachment = Attachment.find(params[:id])
  end

end

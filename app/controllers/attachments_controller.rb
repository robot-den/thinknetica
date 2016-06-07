class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: :destroy

  respond_to :js

  def destroy
    authorize! :destroy, @attachment
    @attachment.destroy
    respond_with @attachment
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end

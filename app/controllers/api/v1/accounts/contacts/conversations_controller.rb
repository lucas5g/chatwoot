class Api::V1::Accounts::Contacts::ConversationsController < Api::V1::Accounts::Contacts::BaseController
  RESULTS_PER_PAGE = 10

  before_action :set_current_page, only: [:index]

  def index
    # Start with all conversations for this contact
    conversations = Current.account.conversations.includes(
      :assignee, :contact, :inbox, :taggings
    ).where(contact_id: @contact.id)

    # Apply permission-based filtering using the existing service
    conversations = Conversations::PermissionFilterService.new(
      conversations,
      Current.user,
      Current.account
    ).perform

    @conversations = conversations.order(last_activity_at: :desc)
                                  .page(@current_page)
                                  .per(RESULTS_PER_PAGE)
  end

  private

  def set_current_page
    @current_page = params[:page] || 1
  end
end

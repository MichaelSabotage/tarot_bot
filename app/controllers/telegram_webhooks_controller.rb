class TelegramWebhooksController < Telegram::Bot::UpdatesController
  before_action :authentication

  def help!(*)
    respond_with :message, text: t(".content")
  end

  def start!(*)
    if from["id"] == Rails.application.credentials.sabotage_id
      reply_with :message, text: "Приветствую Создатель"
    elsif from["id"] == Rails.application.credentials.kris_id
      reply_with :message, text: "Приветствую Хозяйка 🌘"
    else
      reply_with :message, text: "Приветствую #{from['first_name']} #{from['last_name']}!"
    end
  end

  def message(_message)
    respond_with :message, text: t(".content")
  end

  def action_missing(_action, *_args)
    return unless action_type == :command

    respond_with :message,
                 text: t("telegram_webhooks.action_missing.command", command: action_options[:command])
  end

  private

  def authentication
    @user = User.find_or_create_by(id: from["id"], first_name: from["first_name"], last_name: from["last_name"],
                                   username: from["username"])
  end
end

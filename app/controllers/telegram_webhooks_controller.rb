class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include UsersController

  before_action :current_user

  def action_missing(_action, *_args)
    return unless action_type == :command

    respond_with :message,
                 text: t("telegram_webhooks.action_missing.command", command: action_options[:command])
  end

  def start!(*)
    if from["id"] == Rails.application.credentials.sabotage_id
      reply_with :message, text: "Приветствую Создатель"
    elsif from["id"] == Rails.application.credentials.kris_id
      reply_with :message, text: "Приветствую Хозяйка 🌘"
      fill_user_data! unless @current_user.filled?
    else
      reply_with :message, text: "Приветствую Вас #{from['first_name']} #{from['last_name']}!"
    end
  end

  def help!(*)
    respond_with :message, text: t(".content")
  end

  def message(_message)
    respond_with :message, text: t(".content")
  end

  def memo!(*args)
    if args.any?
      session[:memo] = args.join(" ")
      respond_with :message, text: t(".notice")
    else
      respond_with :message, text: t(".prompt")
      save_context :memo!
    end
  end

  def remind_me!(*)
    to_remind = session.delete(:memo)
    reply = to_remind || t(".nothing")
    respond_with :message, text: reply
  end

  def keyboard!(value = nil, *)
    if value
      respond_with :message, text: t(".selected", value: value)
    else
      save_context :keyboard!
      respond_with :message, text: t(".prompt"), reply_markup: {
        keyboard: [t(".buttons")],
        resize_keyboard: true,
        one_time_keyboard: true,
        selective: true
      }
    end
  end

  def inline_keyboard!(*)
    respond_with :message, text: t(".prompt"), reply_markup: {
      inline_keyboard: [
        [
          {text: t(".alert"), callback_data: "alert"},
          {text: t(".no_alert"), callback_data: "no_alert"}
        ],
        [{text: t(".repo"), url: "https://github.com/telegram-bot-rb/telegram-bot"}]
      ]
    }
  end

  def callback_query(data)
    if data == "alert"
      answer_callback_query t(".alert"), show_alert: true
    else
      answer_callback_query t(".no_alert")
    end
  end

  private

  def current_user
    @current_user = User.find_by(id: from["id"])
    @current_user ||= User.create(id: from["id"], first_name: from["first_name"], last_name: from["last_name"],
                                  username: from["username"])
  end
end

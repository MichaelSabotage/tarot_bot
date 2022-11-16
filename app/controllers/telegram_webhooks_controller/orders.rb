module TelegramWebhooksController::Orders
  def make_an_order_callback_query(reading_id = nil, *)
    session[:reading_id] = reading_id
    @current_user.filled? ? make_an_order : fill_user_data
  end

  def make_an_order(*)
    if @current_user.filled?
      reading_id = session[:reading_id].to_i
      session.delete(:reading_id)
      order = Order.create(user_id: @current_user.id, reading_id: reading_id, date: Time.zone.today, status: "Создан")
      session[:order_id] = order.id
      fill_order
    else
      fill_user_data
    end
  end

  def fill_order(comment = nil, *)
    if comment
      order_id = session[:order_id]
      session.delete(:order_id)
      order = Order.find(order_id)
      order.update(comment: payload["text"], status: "На согласовании")
      respond_with :message, text: "Спасибо за ваш заказ!\n" \
                                   "Хозяйка в ближайшее время согласует стоимость\n" \
                                   "Я дам вам знать когда это произойдёт и что делать дальше\n" \
                                   "Если у неё возникнут вопросы, она свяжется с вами напрямую"
      new_order_notification(order)
    else
      save_context :fill_order
      respond_with :message, text: "Необходимо оставить комментарий к заказу\n" \
                                   "Напишите что бы вы хотели спросить, узнать или прояснить у Хозяйки"
    end
  end

  def new_order_notification(order)
    admin = Rails.application.credentials.sabotage_id
    bot.send_message chat_id: admin, text: "Хозяйка,\n" \
                                           "У Вас новый заказ от #{order.user.first_name} @#{order.user.username}\n" \
                                           "Нужен расклад: #{order.reading.name}\n" \
                                           "Базовая цена: #{order.reading.basic_price}₽\n" \
                                           "Комментарий к заказу: #{order.comment}\n" \
  end
end

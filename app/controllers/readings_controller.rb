module ReadingsController
  include Telegram::Bot::UpdatesController::CallbackQueryContext

  def select_topic_callback_query(id = nil, *)
    respond_with :message, text: "Список раскладов:"
    Reading.where(topic_id: id).each do |reading|
      respond_with :message, text: reading.name, reply_markup: {
        inline_keyboard: [
          [
            {text: "Подробнее", callback_data: "reading_description: #{reading.id}"},
            {text: "Сделать заказ", callback_data: "make_an_order: #{reading.id}, #{@current_user.id}"}
          ],
          [
            {text: "Назад", callback_data: "select_area: #{reading.topic.area_id}"}
          ]
        ]
      }
    end
  end

  def reading_description_callback_query(id = nil, *)
    reading = Reading.find(id)
    text = "#{reading.name}:\n#{reading.description}\nБазовая цена: #{reading.basic_price}₽\n" \
           "Примерное время выполнения заказа: #{reading.processing_time} минут"
    respond_with :message, text: text, reply_markup: {
      inline_keyboard: [
        [
          {text: "Назад", callback_data: "select_topic: #{reading.topic_id}"},
          {text: "Сделать заказ", callback_data: "make_an_order: #{reading.id}, #{@current_user.id}"}
        ]
      ]
    }
  end

  def make_an_order_callback_query(*)
    respond_with :message, text: "В разработке"
  end
end

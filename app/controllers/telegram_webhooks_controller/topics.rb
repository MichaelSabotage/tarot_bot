module TelegramWebhooksController::Topics
  def select_area_callback_query(id = nil, *)
    respond_with :message, text: "Выберете тему:"
    Topic.where(area_id: id).each do |topic|
      respond_with :message, text: topic.name, reply_markup: {
        inline_keyboard: [
          [
            {text: "Подробнее", callback_data: "topic_description: #{topic.id}"},
            {text: "Выбрать", callback_data: "select_topic: #{topic.id}"}
          ],
          [
            {text: "Назад", callback_data: "areas_list:"}
          ]
        ]
      }
    end
  end

  def topic_description_callback_query(id = nil, *)
    topic = Topic.find(id)
    respond_with :message, text: "#{topic.name}:\n#{topic.description}", reply_markup: {
      inline_keyboard: [
        [
          {text: "Назад", callback_data: "select_area: #{topic.area.id}"},
          {text: "Выбрать", callback_data: "select_topic: #{topic.id}"}
        ]
      ]
    }
  end
end

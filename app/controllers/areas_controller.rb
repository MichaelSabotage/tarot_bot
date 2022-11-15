module AreasController
  include Telegram::Bot::UpdatesController::CallbackQueryContext

  def areas_list!(*)
    respond_with :message, text: "Выберете область:"
    Area.all.each do |area|
      respond_with :message, text: area.name, reply_markup: {
        inline_keyboard: [
          [
            {text: "Подробнее", callback_data: "area_description: #{area.id}"},
            {text: "Выбрать", callback_data: "select_area: #{area.id}"}
          ]
        ]
      }
    end
  end

  def area_description_callback_query(id = nil, *)
    area = Area.find(id)
    respond_with :message, text: "#{area.name}:\n#{area.description}", reply_markup: {
      inline_keyboard: [
        [
          {text: "Назад", callback_data: "areas_list:"},
          {text: "Выбрать", callback_data: "select_area: #{area.id}"}
        ]
      ]
    }
  end

  def areas_list_callback_query(*)
    areas_list!
  end
end

module UsersController
  def fill_user_data!(*)
    bot.send_message chat_id: from["id"], text: "Для заказа требуется немного информации о вас"
    check_name!
  end

  def check_name!(value = nil, *)
    case value
    when "Да"
      phone!
    when "Нет"
      rename!
    else
      save_context :check_name!
      respond_with :message, text: "#{from['first_name']} ваше настоящее имя?", reply_markup: {
        keyboard: [["Да"], ["Нет"]],
        resize_keyboard: true,
        one_time_keyboard: true,
        selective: true
      }
    end
  end

  def rename!(first_name = nil, *)
    if first_name
      if @current_user.update(first_name: first_name)
        phone!
      else
        save_context :rename!
        respond_with :message, text: "Укажите корректное имя"
      end
    else
      save_context :rename!
      respond_with :message, text: "Как вас зовут?"
    end
  end

  def phone!(phone = nil, *)
    if phone
      phone = format_phone(phone)
      if @current_user.update(phone: phone)
        birth_date!
      else
        save_context :phone!
        respond_with :message, text: "Укажите корректный номер телефона"
      end
    else
      save_context :phone!
      respond_with :message, text: "Укажите свой номер телефона для обратной связи"
    end
  end

  def birth_date!(birth_date = nil, *)
    if birth_date
      if @current_user.update(birth_date: birth_date)
        profession!
      else
        save_context :birth_date!
        respond_with :message, text: "Дата рождения некорректна, формат ДД.ММ.ГГГГ"
      end
    else
      save_context :birth_date!
      respond_with :message, text: "Укажите свою дату рождения в формате ДД.ММ.ГГГГ, вам должно быть больше 18 лет"
    end
  end

  def profession!(profession = nil, *)
    if profession
      if @current_user.update(profession: profession)
        family_status!
      else
        save_context :profession!
        respond_with :message, text: "Род деятельности не может быть пустым"
      end
    else
      save_context :profession!
      respond_with :message, text: "Кем вы работаете?"
    end
  end

  def family_status!(family_status = nil, *)
    keyboard = [["Свободен/Свободна"],
                ["Отношения"],
                ["Брак"],
                ["Развод"],
                ["Вдовец/Вдова"]]
    if keyboard.include?([family_status])
      @current_user.update(family_status: family_status)
      children_count!
    else
      save_context :family_status!
      respond_with :message, text: "Ваше семейное положение?", reply_markup: {
        keyboard: keyboard,
        resize_keyboard: true,
        one_time_keyboard: true,
        selective: true
      }
    end
  end

  def children_count!(children_count = nil, *)
    keyboard = [["0"],
                ["1"],
                ["2"],
                ["3+"]]
    if keyboard.include?([children_count])
      @current_user.update(children_count: children_count)
      respond_with :message,
                   text: "Спасибо, на этом всё, ваши данные сохранены, теперь вы можете сделать заказ (в разработке)"
    else
      save_context :children_count!
      respond_with :message, text: "Сколько у вас детей?", reply_markup: {
        keyboard: keyboard,
        resize_keyboard: true,
        one_time_keyboard: true,
        selective: true
      }
    end
  end

  private

  def format_phone(phone)
    phone = phone.gsub(/[^\p{L}\s\d]/, "")
    case phone[0]
    when "7"
      phone.sub("7", "+7")
    when "8"
      phone.sub("8", "+7")
    when "9"
      phone.insert(0, "+7")
    else
      "Incorrect"
    end
  end
end

class OrderDecorator < Draper::Decorator
  delegate_all

  def all_cartridges
    result = Hash.new(0)
    object.customer.cartridges.joins(:cartridge_service_guide).pluck(:model).each do |cartridge|
      result[cartridge] += 1
    end
    result
  end

  def all_printers
    result = []
    object.customer.printers.joins(:printer_service_guide).pluck(:model, :additional_data, :masters_note).each do |printer, additional_data, masters_note|
      result << [printer, additional_data, masters_note]
    end
    result
  end

  def total_cartridge_count
    object.customer.cartridges.count
  end

  def completing_date
    date_of_complete.nil? ? 'Не назначена' : date_of_complete.to_date.strftime('%d.%m.%Y')
  end

  def display_suitable_time_start
    suitable_time_start ? "С #{suitable_time_start.strftime("%H:%M")}" : ''
  end

  def display_suitable_time_end
    suitable_time_end ? "До #{suitable_time_end.strftime("%H:%M")}" : ''
  end

  def time_hash(begin_phrase = nil)
    time = Hash.new(0)

    (0..23).to_a.each do |h| 
      hour = "0#{h}".last(2)
      time_whole = "#{hour}:00"
      time_half = "#{hour}:30"
      time[ time_whole ] = "#{begin_phrase}#{time_whole}"
      time[ time_half ] = "#{begin_phrase}#{time_half}"
    end

    time
  end

  def status_collection
    collection = Hash.new(0)

    collection['pending'] = "Не распределен"
    collection['signed'] = "Мастер назначен"
    collection['completed'] = "Заказ выполнен"
    collection['closed'] = "Заказ закрыт"
    collection['canceled'] = "Заказ отменен"
    
    collection
  end

end

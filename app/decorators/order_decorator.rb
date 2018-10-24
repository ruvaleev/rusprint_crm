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

end

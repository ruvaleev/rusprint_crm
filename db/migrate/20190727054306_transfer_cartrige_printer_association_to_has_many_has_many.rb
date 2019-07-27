class TransferCartrigePrinterAssociationToHasManyHasMany < ActiveRecord::Migration[5.1]
  def up
    CartridgeServiceGuide.all.group_by(&:model).each do |model, cartridges|
      cartridge = cartridges.first

      if cartridges.count > 1
        cartridges.each { |c| cartridge.printer_service_guides << PrinterServiceGuide.find(c.printer_service_guide_id) }
        (cartridges - [cartridge]).each { |c| c.destroy }
      else
        cartridge.printer_service_guides << PrinterServiceGuide.find(cartridge.printer_service_guide_id)
      end
    end

    remove_column :cartridge_service_guides, :printer_service_guide_id
  end

  def down
    # ATTENTION!!! This migration will work only when you will delete uniqueness validation from the model (CSG)
    # ВНИМАНИЕ!!! Чтобы миграция работала, необходимо удалить валидацию уникальности из модели (CSG)
    add_reference :cartridge_service_guides, :printer_service_guide

    CartridgeServiceGuide.all.each do |csg|
      attributes = csg.attributes.except('id')
      printers = csg.printers.pluck(:id)
      printers.each do |id|
        if id.eql? printers.first
          csg.update(printer_service_guide_id: id)
        else
          CartridgeServiceGuide.create(attributes.merge("printer_service_guide_id" => id))
        end
      end
    end
  end
end

class TransferCartrigePrinterAssociationToHasManyHasMany < ActiveRecord::Migration[5.1]
  def change
    CartridgeServiceGuide.all.group_by(&:model).each do |model, cartridges|
      cartridge = cartridges.first

      if cartridges.count > 1
        cartridges.each { |c| c.printer_service_guides << PrinterServiceGuide.find(c.printer_service_guide_id) }
        (cartridges - [cartridge]).each { |c| c.destroy }
      else
        cartridge.printer_service_guides << PrinterServiceGuide.find(cartridge.printer_service_guide_id)
      end
    end

    remove_column :cartridge_service_guides, :printer_service_guide_id
  end
end

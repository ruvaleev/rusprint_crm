# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Order.destroy_all
Printer.destroy_all
PrinterServiceGuide.destroy_all
CartridgeServiceGuide.destroy_all
Company.destroy_all
User.destroy_all

# Создаем роли
['customer', 'banned', 'manager', 'master', 'admin'].each do |role|
  Role.find_or_create_by({name: role})
end

# Создаем пользователей
hash_users = 11.times.map do
  {
    name: FFaker::NameRU.first_name,
    second_name: FFaker::NameRU.last_name,
    email: FFaker::Internet.safe_email,
    telephone: FFaker::PhoneNumberIT.mobile_phone_number,
    password: FFaker::Internet.password,
    role: Role.find_by_name('customer')
  }
end

users = User.create! hash_users

# Создаем компании
hash_companies = 7.times.map do 
  {
    manager: users.first,
    name: FFaker::Company.name,
    adress: FFaker::AddressRU.street_address,
    telephone: FFaker::PhoneNumberIT.mobile_phone_number,
    email: FFaker::Internet.safe_email
  }
end

companies = Company.create! hash_companies

i = 0
users.last(7).each do |user|
  user.update(employer_id: companies[i].id)
  i+=1
end

# Создаем сервисный справочник принтеров
hash_printer_service_guides = 50.times.map do
  {
    vendor: [ 'Hp', 'Kyocera', 'Samsung', 'Oki', 'Panasonic' ][rand(0..4)],
    model: FFaker::Product.model,
    type_of_system: 'laser',
    fuser_life_count: 100000,
    sheet_size: [ 'A4', 'A4', 'A4', 'A3', 'A2' ][rand(1...5)]
  }
end

printer_service_guides = PrinterServiceGuide.create! hash_printer_service_guides

# Создаем принтеры для каждой компании
companies.each do |company|
  rand(1...5).times.map do
    company.printers.create(  serial_number: FFaker::Vehicle.vin,
                              fuser_life_count: rand(800..200000),
                              additional_data: [FFaker::BaconIpsum.phrase][rand(0..2)] || '',
                              masters_note: [FFaker::BaconIpsum.phrase][rand(0..4)] || '',
                              printer_service_guide: printer_service_guides[rand(0...printer_service_guides.count)] )
  end
end

# Создаем сервисный справочник картриджей для каждого принтера в сервисном справочнике принтеров
printer_service_guides.each do |psg|
  rand(1..5).times.map do
    psg.cartridge_service_guides.create( model: FFaker::Product.model,
                                        toner_life_count: [1000, 1600, 2000, 5000, 10000][rand(0..5)],
                                        price: [395, 595, 795, 995, 1395][rand(0..5)],
                                        color: ['color', 'black'][rand(0..1)] )
  end
end

# ДЕБАЖИМ
result = []
printer_service_guides.each do |psg|
  result << psg.id if psg.cartridge_service_guides.empty?
end

# map-нуться по всем и &:error к cartridge_service_guide
puts "printer_service_guides содержит #{printer_service_guides.count} элементов"
puts "cartridge_service_guide содержит #{CartridgeServiceGuide.all.count} элементов"
puts "result содержит #{result} элементы"

# Создаем картриджи для каждой компании
# companies.each do |company|
#   company.printers.each do |printer|
#     puts "принтер сейчас #{printer.inspect}"
#     rand(1...7).times.map do
#       all_csg = printer.printer_service_guide.cartridge_service_guides
#       puts all_csg.map(&:errors)
#       puts "all_csg сейчас #{all_csg.inspect}"
#       csg = all_csg[rand(0...all_csg.count)]
#       puts "csg сейчас #{csg.inspect}"
#       company.cartridges.create(  cartridge_service_guide: csg,
#                                   price_for_customer: csg.price.to_i + [-100, 0, 100][rand(0..2)],
#                                   additional_data: [FFaker::HipsterIpsum.phrase][rand(0..3)],
#                                   masters_note: [FFaker::HipsterIpsum.phrase][rand(0..3)] )
#     end
#   end
# end 

# Создаем заказы
hash_orders = 10.times.map do
  customer = companies[rand(0...companies.count)]
  cartridges = Hash.new(0)
  revenue = 0
  sum_qnt = 0
  customer.printers.each do |printer|
    qnt = rand(1..12)
    cartridges[printer.possible_cartridges.first] = qnt
    revenue += [495, 595, 695, 745, 995][rand(5)] * qnt
    sum_qnt += qnt
  end
  cartridges_field = ''
  cartridges.each do |model, qnt|
    unless model.nil?
      cartridges_field << "#{model.model} - #{qnt} шт, "
    end
  end
  cartridges_field = cartridges_field.chomp(', ')

  printers_field = ''
  customer.printers.each do |printer|
    unless printer.nil?
      printers_field << "#{printer.printer_service_guide.model} - 1 шт, "
    end
  end
  printers_field = printers_field.chomp(', ')
  
  suitable_time = ["08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30"]
  i = rand(23)
  suitable_time_start = suitable_time[i]
  suitable_time_end = suitable_time[i + 4]

  order = Order.new( date_of_order: date_of_order = FFaker::Time.between(1.months.ago, 2.weeks.ago),
                  date_of_complete: date_of_complete = date_of_order + rand(2),
                  suitable_time_start: suitable_time_start,
                  suitable_time_end: suitable_time_end,
                  additional_data: FFaker::HipsterIpsum.phrase,
                  printers: printers_field,
                  cartridges: cartridges_field,
                  qnt: sum_qnt,
                  revenue: revenue, 
                  expense: expense = revenue * ((rand(0.2..0.4))*100).to_i.to_f/100, 
                  profit: profit = revenue - expense, 
                  customer_id: customer.id, 
                  manager_id: rand(users[0].id..users[1].id), 
                  master_id: rand(users[2].id..users[3].id) )

  if order.save
    puts "Order #{order.id} добавлен"
  else
    puts "Order имеет ошибки: #{order.errors.messages}"
  end

end
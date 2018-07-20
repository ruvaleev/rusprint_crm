# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Order.destroy_all
Company.destroy_all
User.destroy_all




hash_users = 11.times.map do
  {
    name: FFaker::NameRU.first_name,
    second_name: FFaker::NameRU.last_name,
    email: FFaker::Internet.safe_email,
    telephone: FFaker::PhoneNumberIT.mobile_phone_number,
    password: FFaker::Internet.password
  }
end

users = User.create! hash_users

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

hash_orders = 10.times.map do
  {
    date_of_order: date_of_order = FFaker::Time.between(1.months.ago, 2.weeks.ago),
    date_of_complete: date_of_complete = date_of_order + rand(2),
    suitable_time: date_of_complete + rand(-24...24),
    additional_data: FFaker::HipsterIpsum.phrase,
    printers: [ 'Hp ', 'Kyocera ', 'Samsung ', 'Oki ', 'Panasonic ' ][rand(1...5)] + FFaker::Product.model,
    cartridges: FFaker::Product.model,
    revenue: revenue = rand(995...15990), 
    expense: expense = revenue * ((rand(0.2...0.4))*100).to_i.to_f/100, 
    profit: profit = revenue - expense, 
    customer_id: rand(companies.first.id...companies.last.id), 
    manager_id: rand(users[0].id...users[1].id), 
    master_id: rand(users[2].id...users[3].id)
  }
end

orders = Order.create! hash_orders
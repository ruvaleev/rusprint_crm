FactoryBot.define do
  factory :role, class: 'Role' do
    name { 'customer' }
  end

  factory :admin_role, class: 'Role' do
    name { 'admin' }
  end

  factory :manager_role, class: 'Role' do
    name { 'manager' }
  end
end

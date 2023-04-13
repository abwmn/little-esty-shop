# 1. Merchant Dashboard

# As a merchant,
# When I visit my merchant dashboard (/merchants/merchant_id/dashboard)
# Then I see the name of my merchant
require 'rails_helper'

RSpec.describe 'Merchant Show Dashboard Page', type: :feature do
  let!(:merchant1) {Merchant.create!(name:'Steve')}
  let!(:merchant2) {Merchant.create!(name:'Fred')}

  describe "As a merchant visiting '/merchants/:id/dashboard'" do
    it 'I see the name of my merchant' do
      visit merchant_dashboard_path(merchant1)
      
      expect(page).to have_content('Steve')
    end
    
    it 'has a link to merchant items index' do
      visit merchant_dashboard_path(merchant1)
      
      expect(page).to have_link('My Items')
      click_link("My Items")
      expect(current_path).to eq(merchant_items_path(merchant1))
    end
    
    it 'has a link to merchant invoice index' do
      visit merchant_dashboard_path(merchant1)
      
      expect(page).to have_link('My Invoices')
      click_link("My Invoices")
      expect(current_path).to eq(merchant_invoices_path(merchant1))
    end

    it 'I see the names of the top 5 customers with the largest number of successful transactions with my merchant and their transaction count' do
      merchant1 = create(:merchant, :with_items)
      customer1, customer2, customer3, customer4, customer5, customer6 = create_list(:customer, 6)
    
      [customer1, customer2, customer3, customer4, customer5].each do |customer|
        invoice = create(:invoice, customer: customer)
        item = merchant1.items.sample
        create(:invoice_item, invoice: invoice, item: item)
        create_list(:transaction, 5, :successful, invoice: invoice)
      end
    
      invoice = create(:invoice, customer: customer6)
      item = merchant1.items.sample
      create(:invoice_item, invoice: invoice, item: item)
      create_list(:transaction, 2, :successful, invoice: invoice)
    
      visit merchant_dashboard_path(merchant1)

      # require 'pry'; binding.pry
    
      within("#top-customers") do
        expect(page).to have_content("#{customer1.full_name}: 5 successful transactions")
        expect(page).to have_content("#{customer2.full_name}: 5 successful transactions")
        expect(page).to have_content("#{customer3.full_name}: 5 successful transactions")
        expect(page).to have_content("#{customer4.full_name}: 5 successful transactions")
        expect(page).to have_content("#{customer5.full_name}: 5 successful transactions")
    
        expect(page).not_to have_content("#{customer6.full_name}")
      end
    end
  end
end


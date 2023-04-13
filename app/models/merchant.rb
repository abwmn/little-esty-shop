class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items
  has_many :customers, through: :invoices

  def top_five_customers
    customers
      .joins(invoices: [:transactions, :invoice_items])
      .where(transactions: { result: 'success' })
      .select('customers.*, COUNT(transactions.id) AS successful_transactions_count')
      .group('customers.id')
      .order(successful_transactions_count: :desc)
      .limit(5)  
  end  
end
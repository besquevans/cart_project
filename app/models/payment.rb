class Payment < ApplicationRecord
  belongs_to :order

  PAYMENT_METHODS = %w(Credit WebATM ATM)
  #輸出字串陣列 (Array of string)
  validates_inclusion_of :payment_method, in: PAYMENT_METHODS
  #驗證 payment_method 屬性的值要包含在 PAYMENT_METHODS 清單裡

  def deadline
    Date.today + 3.days
  end
end

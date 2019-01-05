class Payment < ApplicationRecord
  after_update :update_order_status
  belongs_to :order

  PAYMENT_METHODS = %w(Credit WebATM ATM)
  #輸出字串陣列 (Array of string)
  validates_inclusion_of :payment_method, in: PAYMENT_METHODS
  #驗證 payment_method 屬性的值要包含在 PAYMENT_METHODS 清單裡

  def deadline
    Date.today + 3.days
  end

  def self.find_and_process(params)
    data = Spgateway.decrypt(params['TradeInfo'], params['TradeSha'])
 
    if data
      payment = Payment.find(data['Result']['MerchantOrderNo'].to_i)
       # 根據參數的 MerchantOrderNo，查出 payment 實例
      if params['Status'] == 'SUCCESS'
        payment.paid_at = Time.now
      end
      payment.params = data

      # 更新相關的 payment 與 order 屬性
      return payment
    else
      return nil
    end
  end

  def update_order_status
    if self.paid_at
      order = self.order
      order.update(payment_status: "paid")
    end
  end
end

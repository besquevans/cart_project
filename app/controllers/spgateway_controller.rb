class SpgatewayController < ApplicationController
  skip_before_action :verify_authenticity_token  
  #關閉 CSRF 安全機制

  def return
    # 比對回傳的 SHA 和我們自行加密的 SHA 是否一樣

    trade_info = spagatway_params['TradeInfo']
    trade_sha = spagatway_params['TradeSha']

    data = Spgateway.decrypt(trade_info, trade_sha)

    # 根據參數的 MerchantOrderNo，查出 payment 實例
    # 更新相關的 payment 與 order 屬性
    if data
      payment = Payment.find(data['Result']['MerchantOrderNo'].to_i)
      if params['Status'] == 'SUCCESS'
        payment.paid_at = Time.now
      end
      payment.params = data
    end

    if payment&.save
      order = payment.order
      order.update(payment_status: "paid")
      # send paid email
      flash[:notice] = "#{payment.sn} paid"
    else
      flash[:alert] = "Something wrong!!!"
    end

    # 動作完成，導回訂單索引頁
    redirect_to orders_path
  end

  private

  # 取出必要參數
  def spagatway_params
    params.slice("Status", "MerchantID", "Version", "TradeInfo", "TradeSha")
  end
end
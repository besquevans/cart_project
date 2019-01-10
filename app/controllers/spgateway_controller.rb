class SpgatewayController < ApplicationController
  skip_before_action :verify_authenticity_token

  def return
    payment = Payment.find_and_process(spagatway_params)
    #把相關程式碼歸類到 Payment model 

    if payment&.save
      #相關程式碼移到 Payment model, 改用after_update :update_order_status
      # send paid email
      flash[:notice] = "#{payment.sn} paid"
    else
      flash[:alert] = "Something wrong!!!"
    end
    # 動作完成，導回訂單索引頁
    redirect_to orders_path
  end

  def notify
    payment = Payment.find_and_process(spagatway_params)

    if payment&.save
      # send paid email
      render text: "1|OK"
    else
      render text: "0|ErrorMessage"
    end
    byebug
  end
  

  private

  # 取出必要參數
  def spagatway_params
    params.slice("Status", "MerchantID", "Version", "TradeInfo", "TradeSha")
  end
end
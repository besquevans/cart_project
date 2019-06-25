require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  it "signup via email and password" do
    post "signup", params: { email: '123@gmail.com', password: '123123' }
    user = User.find_by_email('123@gmail.com')
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq({
      'message' => 'sign up success',
      'user_id' => user.id
    })
  end

  #建立一個使用者，然後向 api/v1/login 發出 POST 請求，並傳入該使用者的帳號密碼
  #預期得到的回應是 response status 200，而且 response body 是可以解析的 JSON
  it "login via email and password" do
    user = create(:user, email: '123@gmail.com', password: '123123')
    post "login", params: { email: user.email, password: '123123' }

    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq({
      'message' => 'ok',
      'auth_token' => user.authentication_token
    })
  end

  it "login via facebook access_token" do
    # 準備測試資料
    # 產生測試用的 User 物件
    user = create(:user, email: '123@gmail.com', password: '123123')
    # 偽造 FB 的使用者資訊
    fb_data = { "id" => "123", "email" => "123@gmail.com", "name" => "fung" }
    # 偽造 FB 權杖與臉書回傳資料 auth_hash
    fb_access_token = 'blablabla'
    auth_hash = double('OmniAuth::AuthHash')

    # 定義呼叫相關方法後的期待回傳值
    allow(User).to receive(:get_facebook_user_data).with(fb_access_token).and_return(fb_data)

    allow(OmniAuth::AuthHash).to receive(:new).and_return(auth_hash)
    allow(User).to receive(:from_omniauth).with(auth_hash).and_return(user)

    # 以偽造的 FB 權杖發出登入請求，預期登入成功，取得 auth_token
    post "login", params: { access_token: fb_access_token }

    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq({
      'message' => 'ok',
      'auth_token' => user.authentication_token
    })
  end

  it "logout succesgully" do
    user = create(:user, email: '123@gmail.com', password: '123123')
    token = user.authentication_token

    post "logout", params: { auth_token: user.authentication_token }

    expect(response).to have_http_status(200)
    user.reload
    expect(user.authentication_token).not_to eq(token)
    #為避免 user 變數因快取而沒有反應到資料庫最新狀況，先做一次 reload，
    #確保 user 去重新讀取資料庫裡的紀錄。做完確保動作後，我們把剛才存下的 token 叫出來對照
  end
end
namespace :dev do
  # 請先執行 rails dev:fake_user，可以產生 20 個資料完整的 User 紀錄
  # 其他測試用的假資料請依需要自行撰寫
  task fake_user: :environment do
    User.destroy_all

    User.create!(
      email: "root@mail.com",
      password: "123456",
      role: "admin"
    )
    puts "root"

    10.times do |i|
      user = User.new(
        email: FFaker::Internet.free_email,
        password: "123456",     
      )

      user.save!     
    end
    puts "#{User.count}users"
  end

  task fake_product: :environment do
    Product.destroy_all
    url = "http://www.splashbase.co/api/v1/images/random"   

    20.times do
      response = RestClient.get(url)
      data = JSON.parse(response.body)
      product = Product.create!(        
        name: FFaker::Product.product,    
        description: FFaker::Lorem.paragraph,
        price: rand(1..20),
        remote_image_url: data["url"]
        #image: FFaker::Avatar.image
      )
    end

    puts "have created fake products"
    puts "now you have #{Product.count} products data"
  end

  task fake_order: :environment do
    puts "Create fake orders for development"
    Order.destroy_all
    Cart.destroy_all

    20.times do
      user = User.all.sample
      cart = Cart.create!

      #put product into cart
      rand(10).times do
        product = Product.all.sample
        cart.add_cart_item(product)
      end

      #checkout cart to order
      order = Order.create!(        
        sn: Time.now.to_i,    
        name: user.email.split("@").first,
        user_id: user.id,
        amount: cart.subtotal,
        address: FFaker::AddressUS.street_address,
        phone: FFaker::PhoneNumber.short_phone_number
      )
      order.add_order_items(cart)
      order.save!
      cart.destroy
    end
    puts "now you have #{Order.count} order record"
  end
end
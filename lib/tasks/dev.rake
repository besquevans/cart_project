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

    30.times do |i|
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

    100.times do
      photo_number = rand(1...30).to_s
      url = "https://s3-ap-northeast-1.amazonaws.com/cart-photo-album/" + photo_number + ".jpg"
      #response = RestClient.get(url)
      #data = JSON.parse(response.body)
      product = Product.create!(        
        name: FFaker::Product.product,    
        description: FFaker::Lorem.paragraph,
        price: rand(1..20),
        remote_image_url: url
        #image: url
      )
    end

    puts "have created fake products"
    puts "now you have #{Product.count} products data"
  end

  task fake_order: :environment do
    puts "Create fake orders for development"
    Order.destroy_all
    Cart.destroy_all

    50.times do |i|
      user = User.all.sample
      cart = Cart.create!

      #put product into cart
      rand(1..10).times do
        product = Product.all.sample
        cart.add_cart_item(product)
      end

      #checkout cart to order
      i < 40 ? pay = "paid" : pay = "not_paid"
      
      i < 30 ? shipping = "shipped" : shipping = "not_shipped"
      
      order = Order.create!(        
        sn: Time.now.to_i + user.id,    
        name: user.email.split("@").first,
        user_id: user.id,
        amount: cart.subtotal,
        address: FFaker::AddressUS.street_address,
        phone: FFaker::PhoneNumber.short_phone_number,
        shipping_status: shipping,
        payment_status: pay
      )
      order.add_order_items(cart)
      cart.destroy
    end
    puts "now you have #{Order.count} order record"
  end

  task fake_all: :environment do
    #Rake::Task['db:migrate'].execute
    #Rake::Task['db:seed'].execute
    Rake::Task['dev:fake_user'].execute
    Rake::Task['dev:fake_product'].execute
    Rake::Task['dev:fake_order'].execute
    #
  end
end
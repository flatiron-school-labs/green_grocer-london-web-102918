require 'pry'

def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |item_hash|
    item_hash.each do |item, attributes|
      if consolidated_cart.include?(item)
        consolidated_cart[item][:count] += 1
      else
        consolidated_cart[item] = attributes
        consolidated_cart[item][:count] = 1
      end
    end
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]

    # `if cart[item_name]` is in case coupon doesn't apply

    if cart[item_name] && cart[item_name][:count] >= coupon[:num]
      cart[item_name][:count] -= coupon[:num]
      if
        cart["#{item_name} W/COUPON"]
        cart["#{item_name} W/COUPON"][:count] +=1
      else

        # working backwards from here - the `else` adds to the hash unless key
        # already exists

        cart["#{item_name} W/COUPON"] = {count: 1, price: coupon[:cost], clearance: cart[item_name][:clearance]}
      end
    end
  end
  cart
end

# would above would work if coupon count and item count identical?
# would give this result when 2 avocados in the cart:
#
#   COUPON {:item => "AVOCADO", :num => 2, :cost => 5.0}
#
#   CART {"AVOCADO" => {:price => 3.0, :clearance => true, :count
#   => 0}, "AVOCADO W/COUPON" => {:price => 5.0, :clearance =>
#   true, :count => 1}}
#

# apply_clearance takes 20% off price if the item is on clearance

def apply_clearance(cart)
  cart.map do |item_name, data|
    if data[:clearance]
      data[:price] = (data[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  price = 0
  consolidated_cart = consolidate_cart(cart)
  apply_coupons(consolidated_cart, coupons)
  apply_clearance(consolidated_cart)

  consolidated_cart.values.each do |item|
    price += (item[:price] * item[:count])
  end
  if price >= 100
    price = (price * 0.9)
  end
  price
end
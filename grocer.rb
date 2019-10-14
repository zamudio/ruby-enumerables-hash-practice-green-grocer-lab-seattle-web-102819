def consolidate_cart(cart)
  combined_cart = {}
  cart.map do |items_in_cart|
    item_name = items_in_cart.keys[0]
    combined_cart[item_name] = items_in_cart.values[0]
    if combined_cart[item_name][:count]
      combined_cart[item_name][:count] += 1
    else
      combined_cart[item_name][:count] = 1
    end
  end
  combined_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    if cart[item] && cart[item][:count] >= coupon[:num]
      if cart["#{item} W/COUPON"]
        cart["#{item} W/COUPON"][:count] += coupon[:num]
      else
        cart["#{item} W/COUPON"] = {
          :price =>coupon[:cost]/coupon[:num],
          :clearance => cart[item][:clearance],
          :count => coupon[:num]
          }
      end
      cart[item][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, clearance_value|
    if clearance_value[:clearance] == true
      clearance_value[:price] = (clearance_value[:price] * 0.8).round(2)
    end
  end
cart
end

def checkout(cart, coupons)
  combined_cart = consolidate_cart(cart)
  coupon_app = apply_coupons(combined_cart, coupons)
  clearance_app = apply_clearance(coupon_app)
  total_cost = 0
  clearance_app.each do |item, clearance_value|
    total_cost += clearance_value[:count] * clearance_value[:price]
  end
  if total_cost >= 100
    total_cost = total_cost * 0.9
  end
  total_cost
end
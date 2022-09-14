hasBopisItem = Input.cart.line_items.any? { |line_item| line_item.properties.any? { |property| property.include?("_pickupstore") } }
hasNonBopisItem = Input.cart.line_items.any? { |line_item| line_item.properties.all? { |property| !property.include?("_pickupstore") } }


if hasBopisItem and hasNonBopisItem
  # Mixed cart case
  # Show all except In Store PickUp
  Output.shipping_rates = Input.shipping_rates.delete_if do |shipping_rate|
    if shipping_rate.name.start_with?("In Store PickUp")
      true
    else
      shipping_rate.change_name(shipping_rate.name + " + In-Store Pickup")
      false
    end
  end
elsif hasBopisItem
  # Only Bopis case
  # Show only In Store PickUp
  Output.shipping_rates = Input.shipping_rates.delete_if do |shipping_rate|
    !shipping_rate.name.start_with?("In Store PickUp")
  end
else
  # Only delivery case
  # Show all except In Store PickUp
  # We could handle via Delivery Plus here
  Output.shipping_rates = Input.shipping_rates.delete_if do |shipping_rate|
    shipping_rate.name.start_with?("In Store PickUp")
  end
end

class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :line_items
  has_many :items, through: :line_items

  def total
    sum = 0
    line_items.each do |line_item|
      sum += (line_item.quantity * line_item.item.price)
    end
    sum
  end

  def checkout
    self.status = 'submitted'
    self.change_inventory
    user.remove_cart
    self.save
  end

  def change_inventory
    if self.status == 'submitted'
      self.line_items.each do |line_item|
        line_item.item.inventory -= line_item.quantity
        line_item.item.save
      end
    end
  end

  def add_item(item_id)
    if item_ids.include?(item_id.to_i)
      current_line_item = line_items.find_by(item_id: item_id)
      current_line_item.quantity += 1
      current_line_item
    else
      line_items.build(item_id: item_id)
    end
  end
end

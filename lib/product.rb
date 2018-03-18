class Product
  def initialize(description, amount, count)
    @description = description
    @price = amount
    @count = count
  end

  def get_description
    @description
  end

  def get_price
    @price
  end

  def get_price_in_pounds
    "£%.2f" % (@price/100.0)
  end

  def get_count
    @count
  end

  def restock(count)
    @count += count
  end

  def available?
    @count > 0
  end

  def print_status
    puts "#{@description} - #{get_price_in_pounds} (#{@count} available)"
  end

  def take
    if available?
      @count -= 1
      return true
    else
      return false
    end
  end
end

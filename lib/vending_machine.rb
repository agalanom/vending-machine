require_relative 'coin_store.rb'
require_relative 'product_store.rb'

class VendingMachine
  def initialize
    @coin_store = CoinStore.new
    @product_store = ProductStore.new
    setup
  end

  def get_value_in_pounds(pence)
    "£%.2f" % (pence/100.0)
  end

  def get_valid_input
    name = gets.chomp
    while name == ''
      name = gets.chomp
    end
    return name
  end

  def ask_user_for_selection
    puts 'Please select product'
    @product_store.print_products
    name = get_valid_input
    p = @product_store.choose_product(name)
    if p != nil
      return p
    else
      ask_user_for_selection
    end
  end

  def buy_product(p)
    puts "#{p.get_description}: #{p.get_price_in_pounds} - Please insert coins"
    puts "Out of change - exact change only!" if !@coin_store.enough_change_available?(p.get_price)
    remaining = -1 * @coin_store.accept_coin(p.get_price)
    if (@coin_store.check_change(remaining) != remaining)
      puts 'Not enough change please select a different product or insert exact change'
      # return everything
      remaining += p.get_price
    else
      p.take
    end
    return remaining
  end

  def give_change(excess)
    if excess > 0
      puts "Thank you for your custom, please take your change of #{get_value_in_pounds(excess)}"
      p @coin_store.calculate_change(excess).map { |c| get_value_in_pounds(c) }
    else
      puts 'Thank you for your custom'
    end
    puts '----------'
  end

  def setup
    p = [
      Product.new('bread', 50, 10),
      Product.new('cake', 150, 5),
      Product.new('apple', 30, 10),
      Product.new('sandwich', 350, 5),
      Product.new('twinkie', 100, 5)
    ]
    @product_store.load_products(p);
    # coin quantities in descending value order
    c = [5, 5, 10, 10, 10, 10, 5, 5]
    @coin_store.load_coins(c)
  end

  def restock_product
    puts 'Enter name of new or existing product to restock. Press enter to stop'
    name = gets.chomp
    if (name == '')
      puts 'Completed product restocking'
      return
    end
    product = @product_store.find_product(name)
    if product
      puts "Existing product #{name}"
      price = product.get_price
    else
      puts "Enter cost of #{name} in pence"
      price = gets.chomp.to_i
    end
    puts "Enter quantity of #{name} to load"
    quantity = gets.chomp.to_i
    puts "Loaded #{name}"
    @product_store.add_product(Product.new(name, price, quantity))
  end

  # run methods
  def run
    loop do
      p = ask_user_for_selection
      remaining = buy_product(p)
      give_change(remaining)
    end
  end

  def restock_products
    product = restock_product
    until product == nil
      product = restock_product
    end
  end

  def restock_coins
    total = @coin_store.total_coins_value
    @coin_store.available_denominations.each do |coin|
      puts "Enter quantity of #{get_value_in_pounds(coin)} coins to load"
  		quantity = gets.chomp.to_i
  		@coin_store.add_coin(coin, quantity)
    end
    new_total = @coin_store.total_coins_value
    puts "Loaded #{get_value_in_pounds(new_total-total)}. Total value of change #{get_value_in_pounds(new_total)}"
  end
end

class CoinStore
  MAX_DENOMINATION = 200

  def initialize
    @coins = {
      200 => 0,
      100 => 0,
      50  => 0,
      20  => 0,
      10  => 0,
      5   => 0,
      2   => 0,
      1   => 0
    }
  end

  def available_denominations
    @coins.keys
  end

  def total_coins_value
    @coins.reduce(0) { |sum, n| sum += n[0] * n[1] }
  end

  def load_coins(coins_array)
    @coins.keys.each_with_index { |k, i| add_coin(k,coins_array[i]) }
  end

  def reset_coins
    @coins.keys.each_with_index { |k, i| @coins[k] = 0 }
  end

  def take_coin(value)
    @coins[value] -= 1
  end

  def add_coin(value, count = 1)
    @coins[value] += count
  end

  def get_valid_coin
    value = gets.chomp.to_i
    if @coins[value] != nil
      return value
    else
      get_valid_coin
    end
  end

  def accept_coin(remaining)
    value = get_valid_coin
    add_coin(value)
    remaining = remaining - value
    if remaining > 0
      puts "Remaining: £%.2f" % (remaining/100.0)
      remaining = accept_coin(remaining)
    end
    return remaining
  end

  def calculate_change(change_required)
    return_to_customer = []
    coin = select_coin(change_required)
    while change_required != 0 && coin != nil
      take_coin(coin)
      return_to_customer << coin
      change_required -= coin
      coin = select_coin(change_required)
    end
    return_to_customer
  end

  def check_change(amount)
    return_to_customer = calculate_change(amount)
    return_to_customer.each { |c| add_coin(c) } # add coins back
    return total_change = return_to_customer.reduce(0) { |sum, c| sum += c }
  end

  def enough_change_available?(price)
    max_change_required = MAX_DENOMINATION - (price % MAX_DENOMINATION)
    # if the price is a multiple of the max denomination no change is needed
    if max_change_required == MAX_DENOMINATION
      true
    else
      check_change(max_change_required) == max_change_required
    end
  end

  def select_coin(change_required)
    found = @coins.find { |denomination, quantity| denomination <= change_required && quantity > 0 }
    found[0] if found
  end

end

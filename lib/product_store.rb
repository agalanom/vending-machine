require_relative './product.rb'

class ProductStore
  def initialize
    @products = {}
  end

  def add_product(p)
    product = @products[p.get_description]
    if (product == nil)
      @products[p.get_description] = p
    else
      product.restock(p.get_count)
    end
  end

  def choose_product(name)
    product = find_product(name)
    if (product != nil)
      if !product.available?
        puts "Sorry, product '#{name}' is out of stock"
        return nil
      end
    else
      puts "Product '#{name}' is not available"
    end
    return product
  end

  def load_products(product_array)
    product_array.each { |p| add_product(p) }
  end

  def print_products()
    @products.each_value { |p| p.print_status}
  end

  def find_product(name)
    @products[name]
  end
end

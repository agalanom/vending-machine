require 'product_store'

describe ProductStore do

  before(:each) do
    @product_store = ProductStore.new
  end

  describe "add_product" do
    context "there are no products" do
      it "adds the product" do
        p = Product.new('bread', 50, 10)
        @product_store.add_product(p)
        expect(@product_store.find_product('bread')).not_to eq(nil)
        expect(@product_store.find_product('bread')).to eq(p)
      end
    end

    context "the product already exists" do
      it "restocks the product" do
        @product_store.add_product(Product.new('bread', 50, 10))
        @product_store.add_product(Product.new('bread', 50, 5))
        expect(@product_store.find_product('bread').get_count).to eq(15)
      end
    end
  end

  describe "choose_product" do
    context "the product is not available" do
      it "displays not available message" do
        expect { @product_store.choose_product('banana') }.to output("Product 'banana' is not available\n").to_stdout
      end
    end

    context "the product is out of stock" do
      it "displays out of stock message" do
        @product_store.add_product(Product.new('bread', 50, 0))
        expect { @product_store.choose_product('bread') }.to output("Sorry, product 'bread' is out of stock\n").to_stdout
      end
    end
  end
end

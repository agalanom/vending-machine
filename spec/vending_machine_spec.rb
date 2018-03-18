require 'vending_machine'
require 'spec_helper'

describe VendingMachine do

  before(:each) do
    @machine = VendingMachine.new
  end

  describe "ask_user_for_selection" do
    context "an available product is selected" do
      it "selects the product" do
        fake_stdin("apple") do
          expect(@machine.ask_user_for_selection).not_to eq(nil)
        end
      end
    end
  end

  describe "buy_product" do
    context "exact coins are inserted" do
      it "returns no change value and dispenses the product" do
        fake_stdin("bread") do
          @product = @machine.ask_user_for_selection
        end
        count = @product.get_count
        fake_stdin(50) do
          expect { @remaining = @machine.buy_product(@product) }.to output("bread: £0.50 - Please insert coins\n").to_stdout
          expect(@remaining).to eq(0)
          expect(@product.get_count).to eq(count - 1)
        end
      end
    end

    context "more coins than the product cost are inserted" do
      it "returns the change and dispenses the product" do
        fake_stdin("apple") do
          @product = @machine.ask_user_for_selection
        end
        fake_stdin(20, 20) do
          expect { @remaining = @machine.buy_product(@product) }.to output("apple: £0.30 - Please insert coins\nRemaining: £0.10\n").to_stdout
          expect(@remaining).to eq(10)
        end
      end
    end
  end
end

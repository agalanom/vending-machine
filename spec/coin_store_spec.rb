require 'coin_store'
require 'spec_helper'

describe CoinStore do

  before(:each) do
    @coin_store = CoinStore.new
  end

  describe "get_valid_coin" do
    it "only accepts numeric input" do
      fake_stdin("test", "one", "two", "10") do
        @value = @coin_store.get_valid_coin
        expect(@value).to eq(10)
      end
    end

    it "only accepts valid denomination" do
      fake_stdin(30, 50) do
        @value = @coin_store.get_valid_coin
        expect(@value).to eq(50)
      end
    end
  end

  describe "accept_coin" do
    context "given £1 towards balance of 100" do
      it "balance is 0" do
        fake_stdin(100) do
          @value = @coin_store.accept_coin(100)
          expect(@value).to eq(0)
        end
      end
    end

    context "given 10, 20, 50 towards balance of 80" do
      it "balance is 0" do
        fake_stdin(10, 20, 50) do
          @value = @coin_store.accept_coin(80)
          expect(@value).to eq(0)
        end
      end
    end

    context "given 50, 100 towards balance of 100" do
      it "balance is -50" do
        fake_stdin(50, 100) do
          @value = @coin_store.accept_coin(100)
          expect(@value).to eq(-50)
        end
      end
    end
  end

  describe "calculate_change" do
    before(:each) do
      @coin_store.load_coins([5, 5, 10, 10, 10, 10, 5, 5])
    end

    describe "total_coins_value" do
      it "calculates the correct total" do
        expect(@coin_store.total_coins_value).to eq(2365)
      end
    end

    context "when the coins required are available" do
      it "returns correct change combination" do
        expect(@coin_store.calculate_change(180)).to eq([100,50,20,10])
        expect(@coin_store.total_coins_value).to eq(2185)
      end

      it "returns correct change combination" do
        expect(@coin_store.calculate_change(78)).to eq([50,20,5,2,1])
        expect(@coin_store.total_coins_value).to eq(2287)
      end

      it "returns no change if exact is provided" do
        expect(@coin_store.calculate_change(0)).to eq([])
        expect(@coin_store.total_coins_value).to eq(2365)
      end
    end
  end

  describe "select_coin" do
    it "does selects the correct coin if available" do
      @coin_store.load_coins([1, 2, 3, 4, 5, 6, 7, 8])
      expect(@coin_store.select_coin(100)).to eq(100)
      expect(@coin_store.select_coin(20)).to eq(20)
    end

    it "does selects the correct coin if available" do
      @coin_store.load_coins([0, 1, 0, 1, 0, 1, 0, 1])
      expect(@coin_store.select_coin(200)).to eq(100)
      expect(@coin_store.select_coin(50)).to eq(20)
    end
  end

  describe "check_change" do
    context "when the coins required are not available" do
      before(:each) do
        @coin_store.load_coins(Array.new(8,0))
      end

      it "does not return change if no coins are available" do
        expect(@coin_store.check_change(100)).to eq(0)
      end

      it "does not return all change if some coins are left" do
        @coin_store.load_coins(Array.new(8,1))
        expect(@coin_store.check_change(44)).to eq(38)
      end
    end
  end

  describe "enough_change_available?" do
    context "when not enough change is available" do
      it "returns false" do
        @coin_store.load_coins([0, 0, 1, 0, 0, 1, 1, 1])
        expect(@coin_store.enough_change_available?(100)).to eq(false)
      end
    end

    context "when enough change is available" do
      it "returns true" do
        @coin_store.load_coins(Array.new(8,2))
        expect(@coin_store.enough_change_available?(100)).to eq(true)
      end
    end
  end

end

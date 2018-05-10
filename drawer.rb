class Drawer
  attr_accessor :strategy

  def initialize(strategy_name, board)
    @strategy = load_strategy_class(strategy_name).new(board)
  end

  def call(coord, idx)
    strategy.call(coord, idx)
  end

  private

  def load_strategy_class(strategy_name)
    file_name = "./drawer_strategies/#{strategy_name}.rb"
    require(file_name)
    Kernel.const_get("DrawerStrategies::#{camelize(strategy_name)}")
  end

  def camelize(name)
    name.to_s.split("_").map(&:capitalize).join("")
  end
end

require 'savon'

class Savon::Client
  alias_method :orig_method_missing, :method_missing
  alias_method :orig_initialize, :initialize

  def initialize(endpoint, options={}, &block)
    orig_initialize endpoint, options
    @soap_config = block
  end

  def method_missing(method, *args, &block)
    orig_method_missing method, args do |soap|
      @soap_config.call soap if @soap_config
      block.call soap unless block.nil?
    end
  end
end
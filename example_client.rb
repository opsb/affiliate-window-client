require 'rubygems'
require 'savon'
require 'savon_ext'

username = ENV['AFFILIATE_WINDOW_ID']
password = ENV['AFFILIATE_WINDOW_PASSWORD']
type = "affiliate"

client = Savon::Client.new "http://api.affiliatewindow.com/v3/AffiliateService?wsdl" do |soap|
  soap.header = {
    "ns1:UserAuthentication" => {
      "env:mustUnderstand" => "1",
      "env:actor" => "http://api.affiliatewindow.com",
      "ns1:iId" => username,
      "ns1:sPassword" => password,
      "ns1:sType" => type
    }
  }
  soap.namespaces = {
    "xmlns:env" => "http://schemas.xmlsoap.org/soap/envelope/",
    "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
    "xmlns:ns1" => "http://api.affiliatewindow.com/"
  }
end

puts client.get_merchant_list

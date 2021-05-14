require 'net/http'
require_relative 'NetworkTransfer'

class HTTPTransfer < NetworkTransfer

    def initialize arguments
        desUri, = arguments
        @desUri = desUri
    end

    def setupTransfer
        @type = "HTTP Protocol"
        @host_ = HTTPTransfer.getHost(@desUri)
        @path_ = HTTPTransfer.getPath(@desUri)
        @query_ = HTTPTransfer.getQuery(@desUri)

        @desAddr = NetworkTransfer.getAddrFromHost(@host_)
        @desPort = 80
        
        @userData = @query_
        @uri = URI::HTTP.build(host: @host_, path: @path_, query: @query_)
    end

    def sendAndWaitData
        puts "Sending and waiting for data..."
        httpResponseObj = Net::HTTP.get_response(@uri)
        puts "Response: #{httpResponseObj.body}"
    end

    def getSrcPort
        Net::HTTP.http_default_port
    end

    def getSrcAddr
        IPSocket.getaddress(Socket.gethostname)
    end 

    private
    def self.getHost uri
        uri.match(/\/\/(.*(.com|.net|.org))/)[1]
    end

    def self.getPath uri
        uri.match(/(?:.com|.net|.org)(.*)\?/)[1]
    end

    def self.getQuery uri
        uri.match(/\?(.*)$/)[1]
    end
end
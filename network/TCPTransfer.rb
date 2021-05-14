require 'socket'
require_relative 'NetworkTransfer'

class TCPTransfer < NetworkTransfer

    def setupTransfer
        @type = "TCP Protocol"
        @server = TCPSocket.open(@desAddr, @desPort)
    end

    def sendAndWaitData
        @client = @server.accept #wait until a client is reached
        @client.puts @userData
        puts @client.inspect
        @client.close
    end

    def getSrcPort
        @desPort
    end

    def getSrcAddr
        @client.addr[-1]
    end
end
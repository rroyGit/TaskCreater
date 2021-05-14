require 'socket'
require_relative 'NetworkTransfer'

class TCPTransfer < NetworkTransfer

    def initialize arguments
        desAddr, desPort, userData = arguments
        @desAddr = desAddr
        @desPort = desPort
        @userData = userData 
    end

    def setupTransfer
        @type = "TCP Protocol"
        begin
            @server = TCPServer.new @desAddr, @desPort
        rescue Exception => e  
            puts "Failed to connect to addr => #{@desAddr} & port => #{@desPort}\n\n"
            puts e.message  
            puts e.backtrace.inspect
            exit 
        end
    end

    def sendAndWaitData
        puts "Waiting to accept a client..."
        @client = @server.accept #wait until a client is reached
        @client.puts @userData
        puts "...message sent to a client."

        clientInfo = @client.inspect.match(/#<(.*)>/)[1]
        @clientAddr = clientInfo.split(",")[-2]
        @clientPort = clientInfo.split(",")[-1]

        @client.close
    end

    def getSrcPort
        @clientPort
    end

    def getSrcAddr
        @clientAddr
    end
end
require "resolv"

class NetworkTransfer
    attr_reader :desAddr, :desUri

    class << self
        attr_accessor :commandArgs
    end

    @commandArgs = []

    def initialize
    end

    def transferData
        childPid = fork do
            startTime = Time.now
            setupTransfer
            sendAndWaitData
            logTransferData startTime
            exit
        end
        Process.wait(childPid)
    end

    private
    def logTransferData startTime
        process_id_ = Utility.getProcessID
        user_name_ = Utility.getUserName
        process_name_ = Utility.getProcessNameByPID process_id_

        srcPort_ = getSrcPort
        srcAddr_ = getSrcAddr
        desAddr_ = @desAddr
        desPort_ = @desPort
        
        amountData_ = "#{@userData.bytesize} Bytes"
        protoType_ = @type
        commandArgs_ = NetworkTransfer.commandArgs

        transferDataHash = {start_time: startTime.inspect, 
        user_name: user_name_, dest_addr: desAddr_, dest_port: desPort_, src_addr: srcAddr_, src_port: srcPort_,
        amount_data: amountData_, proto_type: protoType_, process_name: process_name_, 
        process_command_args: commandArgs_, process_id: process_id_}

        JSONLogger.getJSONLogger.addData "transferData", transferDataHash
        JSONLogger.getJSONLogger.writeData
    end

    def self.getAddrFromHost hostName
        Resolv.getaddress(hostName)
    end
end
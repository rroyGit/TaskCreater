class NetworkTransfer

    def initialize desAddr, desPort, userData

    end

    def initialize desUri
         
    end

    def transferData
        childPid = fork do
            setupTransfer
            sendAndWaitData
            exit
        end
        Process.wait(childPid)
    end
end
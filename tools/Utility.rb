require_relative 'OSFinder'

class Utility
    
    def self.pathExample
        puts "/home/<USER_NAME>/my_folder" if OSFinder.linux?
        puts "C:\\Users\\<USER_NAME\\PC\\my_folder" if OSFinder.windows?
    end

    def self.systemSupported?
        OSFinder.linux? or OSFinder.windows?
    end

    def self.getProcessID
        Process.pid
    end

    def self.getProcessNameByPID processPid
        processName = nil
        if OSFinder.linux?
            processName = `ls`
        elsif OSFinder.windows?
            processName = `tasklist /FI "pid eq #{processPid}"`
        end    
        return processName
    end

    #Used when a process has finished execution because it can
    #not be found in the OS process table
    def self.getProcessNameByPath exePath
        processName = nil
        if OSFinder.linux?
            processName = exePath.split("/")[-1]
        elsif OSFinder.windows?
            processName = exePath.split("\\")[-1]
        end  
        return processName      
    end


    def self.getUserID
        Process.uid
    end

    def self.getUserName
        ENV['USER']
    end
end

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

    # Processes created via fork have their process name set to ruby.
    # This name is not well-defined. In the future, it would be ideal
    # to appropriately update the name of the process via a Ruby API.
    def self.getProcessNameByPID processPid
        processName = nil
        if OSFinder.linux?
            processName = `ps -p #{processPid} -o comm=`
        elsif OSFinder.windows?
            processName = `tasklist /FI "pid eq #{processPid}"`
        end    
        return processName.strip
    end

    # When a process has finished execution, the process entry no longer exists
    # in the OS process table. Thus, retrieve the executable name from the path
    # pointing to the executable. 
    def self.getProcessNameByPath exePath
        processName = nil
        if OSFinder.linux?
            processName = exePath.split("/")[-1]
        elsif OSFinder.windows?
            processName = exePath.split("\\")[-1]
        end  
        return processName.strip      
    end

    def self.getUserID
        Process.uid
    end

    def self.getUserName
        ENV['USER']
    end
end

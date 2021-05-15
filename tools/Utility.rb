require_relative 'OSFinder'

class Utility
    
    def self.pathExample
        puts "/home/<USER_NAME>/my_folder" if OSFinder.unix?
        puts "C:\\Users\\<USER_NAME\\PC\\my_folder" if OSFinder.windows?
    end

    def self.systemSupported?
        OSFinder.linux? or OSFinder.windows? or OSFinder.mac?
    end

    def self.getProcessID
        Process.pid
    end

    # Processes created via fork have their process name set to ruby.
    # This name is not well-defined. In the future, it would be ideal
    # to appropriately update the name of the process via a Ruby API.
    def self.getProcessNameByPID processPid
        processName = `ps -p #{processPid} -o comm=` if OSFinder.unix?
        processName = `tasklist /FI "pid eq #{processPid}"` if OSFinder.windows?
        return processName.strip
    end

    # When a process has finished execution, the process entry no longer exists
    # in the OS process table. Thus, retrieve the executable name from the path
    # pointing to the executable. 
    def self.getProcessNameByPath exePath
        processName = exePath.split("/")[-1] if OSFinder.unix?
        processName = exePath.split("\\")[-1] if OSFinder.windows?
        return processName.strip      
    end

    def self.getUserID
        Process.uid
    end

    def self.getUserName
        ENV['USER']
    end
end

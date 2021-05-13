require_relative 'Utility'

class FileIO
    class << self
        attr_accessor :commandArgs
    end

    @commandArgs = []

    #core feature - create a new file in a child process
    def self.createFile dirPath, fileName
        
    end

    #core feature - delete a file in a child process
    def self.deleteFile filePath
       
    end

    #core feature - write data to a file in a child process
    def self.writeToFile filePath, userData
        
    end

    #--- helper methods ---
    def self.validateDir? dirPath
        if Utility.systemSupported?
            if File::directory? (dirPath)
                true
            else 
                puts "Invalid directory path..."
                false
            end
        else 
            puts "OS is not supported..." 
            false
        end 
    end 

    def self.validateFile? filePath
        if Utility.systemSupported?
            if (not File::directory? (filePath)) && (File::exists? (filePath))
                true
            else 
                puts "Invalid file path: #{filePath}"
                false
            end
        else 
            puts "OS is not supported..." 
            false
        end 
    end 

    def self.validateExe? exePath
        if Utility.systemSupported?
            if File.executable? (exePath)
                true
            else 
                puts "Not an executable: #{exePath}"
                false
            end
        else 
            puts "OS is not supported..." 
            false
        end 
    end 

    #add a forward or backward slash to the end of the received
    #string depending on OS type
    def self.fixateDirPath dirPath
        if OSFinder.linux?
            if not dirPath.end_with? ("/")
               return "#{dirPath}".concat("/")
            end
        elsif OSFinder.windows? 
            if not dirPath.end_with? ("\\")
                return "#{dirPath}".concat("\\")
            end
        end
        return dirPath
    end

    private
end

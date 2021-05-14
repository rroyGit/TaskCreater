require_relative 'Utility'

class FileIO
    class << self
        attr_accessor :commandArgs
    end

    @commandArgs = []

    # Core feature - creates a new file in a child process
    # +dirPath+::  path to the dir where the file should be created
    # +fileName+:: name of the file
    def self.createFile dirPath, fileName
        if FileIO.validateDir? (dirPath)
            childPid = fork do
                startTime = Time.new

                dirPath = FileIO.fixatePath dirPath
                fullFileName = "#{dirPath}#{fileName}"

                aFile = File.new(fullFileName, "w") #Create an empty file
                aFile.close

                FileIO.logFileIOData "createFile", fullFileName, @commandArgs, startTime
                exit 
            end
            Process.wait(childPid)
        end 
    end

    # Core feature - delete a file in a child process
    # +filePath+:: path to the file that is to be deleted
    def self.deleteFile filePath
        if FileIO.validateFile? (filePath)
            childPid = fork do
                startTime = Time.new

                begin
                    File.delete(filePath)
                rescue Errno::ENOENT
                end

                FileIO.logFileIOData "deleteFile", filePath, @commandArgs, startTime
                exit
            end
            Process.wait(childPid)
        end 
    end

    # Core feature - write data to a file in a child process
    # +filePath+:: path to the file that is to be modified 
    # +userFata+:: data to be written to the file. Note - previous content
    #              will be erased. Future implemenattion will allow to append
    #              data to the end of the file.
    def self.writeToFile filePath, userData
        if FileIO.validateFile? (filePath)
            childPid = fork do    
                startTime = Time.new

                aFile = File.write(filePath, userData, mode: "w")

                FileIO.logFileIOData "writeFile", filePath, @commandArgs, startTime
                exit
            end
            Process.wait(childPid)
        end 
    end

    #--- Helper Methods ---
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

    # Add a forward or backward slash to the end of the received
    # string depending on OS type
    def self.fixatePath path_
        if OSFinder.linux?
            if not path_.end_with? ("/")
               return "#{path_}".concat("/")
            end
        elsif OSFinder.windows? 
            if not path_.end_with? ("\\")
                return "#{path_}".concat("\\")
            end
        end
        return path_
    end

    private
    def self.logFileIOData activityDes, filePath_, commandArgs, startTime
        process_id_ = Utility.getProcessID
        user_name_ = Utility.getUserName
        process_name_ = Utility.getProcessNameByPID process_id_

        fileIOHash = {start_time: startTime.inspect, filePath: filePath_, activity: activityDes, 
        user_name: user_name_, process_name: process_name_, 
        process_command_args: commandArgs, process_id: process_id_}

        JSONLogger.getJSONLogger.addData "fileIO", fileIOHash
        JSONLogger.getJSONLogger.writeData
    end
end

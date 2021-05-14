require_relative 'FileIO'
require_relative 'JSONLogger'

class ProcessStart
    #core feature - create a new process wherein the specified executable runs
    def self.startProcess exePath, exeArguments
        require 'open3'
    
        if (FileIO.validateFile? exePath) && (FileIO.validateExe? exePath)
            exeArgumentsString = (exeArguments ==  nil) ? "" : exeArguments.join(" ")

            start_time_ = Time.new

            process_id_ = ProcessStart.executeLinux exePath, exeArgumentsString if OSFinder.linux?
            process_id_ = ProcessStart.executeWin exePath, exeArgumentsString if OSFinder.windows?
                
            #log data
            process_command_args_ = exeArgumentsString
            user_name_ = Utility.getUserName
            process_name_ = Utility.getProcessNameByPath exePath

            processHash = {start_time: start_time_.inspect, user_name: user_name_, process_name: process_name_, 
            process_command_args: process_command_args_, process_id: process_id_}

            JSONLogger.getJSONLogger.addData "startProcess", processHash
            JSONLogger.getJSONLogger.writeData
        end
    end

    private
    def self.executeWin exePath, exeArgumentsString 
        pid = nil
        #   ruby TaskCreator.rb 1 "C:\\Program Files\\Git\\bin\\git.exe" --version
        #   ruby TaskCreator.rb 1 "C:\Program Files\Git\bin\git.exe" --version
        #   "\"C:\\Program Files\\Git\\bin\\git.exe\" --version"

        fullCmd = "\"#{exePath}\" #{exeArgumentsString}"
        Open3.popen3(fullCmd) do |stdin, stdout, stderr, wait_thread|
            puts "stdout: \n#{stdout.read}"
            puts "\n"
            puts "stderr: \n#{stderr.read}"

            pid = wait_thread.pid
            exit_status = wait_thread.value #waits the termination of the process
        end   
        return pid
    end

    def self.executeLinux exePath, exeArgumentsString
        stdin, stdout, stderr, wait_thread = Open3.popen3 exePath, exeArgumentsString
        pid = wait_thread.pid # pid of the started process

        stdin.close
        exit_status = wait_thread.value #waits the termination of the process

        puts "stdout: \n#{stdout.read}"
        puts "\n"
        puts "stderr: \n#{stderr.read}"
        stdout.close
        stderr.close
        return pid
    end
end
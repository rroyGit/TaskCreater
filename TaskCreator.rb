require_relative 'tools/FileIO'
require_relative 'tools/Utility'
require_relative 'network/HTTPTransfer'
require_relative 'network/TCPTransfer'

def usage
    startProccess = "1. |Start Process|"
    createFile =    "2. |Create a new file|"
    deleteFile =    "3. |Delete a file|"
    modifyFile =    "4. |Modify a file|"
    transferData =  "5. |Transfer a file|"

    options = "Choose one of the following options [1-5]:\n
        #{startProccess} [path to executable] [optional command-line arguments] \n
        #{createFile} [location to dir] [file name w/ extension]\n
        #{deleteFile} [file path]\n
        #{modifyFile} [file path] [\"data to add - type String\"]\n
        #{transferData} [Destinaton address] [Destination port] [\"data to send - type String\"]\n"
    
    examples = "Examples:\n    ruby Task_Maker.rb 1 /home/user/src/hello_world\n
    ruby TaskCreator.rb 2 /home/user/src/ hello_world.txt\n
    ruby TaskCreator.rb 3 /home/user/src/hello_world.txt\n
    ruby TaskCreator.rb 4 /home/user/src/hello_world.txt \"Hello There! General Kenobi\"\n
    ruby TaskCreator.rb 5 192.168.1.23 3000 \"It is your Birthday\"\n
    ruby TaskCreator.rb 5 \"http://bing-gnc-service.herokuapp.com/temp?sensorId=1&value=45&seqNum=0\"\n"

    puts "Usage: \n#{options}#{examples}"
end 

def invalidInput
    puts "Not a valid input...try again\n\n"
    usage 
end

#core feature - create a new process wherein the specified executable runs
def startProcess exePath, exeArguments
    require 'open3'
 
    if (FileIO.validateFile? exePath) && (FileIO.validateExe? exePath)
        exeArgumentsString = (exeArguments ==  nil) ? "" : exeArguments.join(" ")

        start_time_ = Time.new

        process_id_ = executeLinux exePath, exeArgumentsString if OSFinder.linux?
        process_id_ = executeWin exePath, exeArgumentsString if OSFinder.windows?
            
        #log data
        process_command_args_ = exeArgumentsString
        user_name_ = Utility.getUserName
        process_name_ = Utility.getProcessNameByPath exePath

        processHash = {start_time: start_time_.inspect, user_name: user_name_, process_name: process_name_, 
        process_command_args: process_command_args_, process_id: process_id_}
    end
end

def executeWin exePath, exeArgumentsString 
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

def executeLinux exePath, exeArgumentsString
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

def handleStartProcess arguments
    if arguments != nil && arguments.length >= 1
        exePath, *exeArguments = arguments
        startProcess exePath, exeArguments
    else
        invalidInput
    end
end

def handleCreateFile arguments
    
end

def handleDeleteFile arguments
    
end

def handleModifyFile arguments
   
end

def handleNetworkTransfer arguments
    
end

def mainHandler
    commandArgs = ARGV
    if commandArgs.length == 0
        usage
        return
    end
       
    userOption, *arguments = commandArgs
   
    case userOption.to_i
    when 1
        handleStartProcess arguments
    when 2
        handleCreateFile arguments
    when 3
        handleDeleteFile arguments
    when 4
        handleModifyFile arguments
    when 5
        handleNetworkTransfer arguments
    else
        invalidInput
    end 
end

#start program
mainHandler
require_relative 'tools/FileIO'
require_relative 'tools/ProcessStart'
require_relative 'tools/JSONLogger'
require_relative 'network/NetworkTransfer'
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
    
    examples = "Examples:\n    ruby TaskCreator.rb 1 /bin/cat /etc/hosts\n
    ruby TaskCreator.rb 1 \"C:\\Program Files\\Git\\bin\\git.exe\" --version\n
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

#action handlers
def handleStartProcess arguments
    if arguments != nil && arguments.length >= 1
        exePath, *exeArguments = arguments
        ProcessStart.startProcess exePath, exeArguments
    else
        invalidInput
    end
end

def handleCreateFile arguments
    if arguments != nil && arguments.length == 2
        fileLocation, fileName = arguments
        FileIO.commandArgs = arguments
        FileIO.createFile fileLocation, fileName
    else
        invalidInput
    end 
end

def handleDeleteFile arguments
    if arguments != nil && arguments.length == 1
        fileName, = arguments
        FileIO.commandArgs = arguments
        FileIO.deleteFile fileName
    else
        invalidInput
    end 
end

def handleModifyFile arguments
    if arguments != nil && arguments.length == 2
        fileName, userData = arguments
        FileIO.commandArgs = arguments
        FileIO.writeToFile fileName, userData
    else
        invalidInput
    end 
end

# Determine and perform transfer of data via either TCP or
# HTTP protocol. If command-line args include an address, a port,
# a string of chars, then TCP wil be used. Otherwise, if it includes 
# an URI then HTTP will be used - currently supports GET requests. 
def handleNetworkTransfer arguments
    if arguments != nil
        NetworkTransfer.commandArgs = arguments

        dataTransfer = HTTPTransfer.new(arguments) if arguments.length == 1
        dataTransfer = TCPTransfer.new(arguments) if arguments.length == 3
        dataTransfer.transferData if not dataTransfer == nil
    else
        invalidInput
    end 
end

# Process command-line args and trigger appropriate action 
def mainHandler
    commandArgs = ARGV
    if commandArgs.length == 0
        usage
        return
    end
       
    userOption, *arguments = commandArgs
    JSONLogger.getJSONLogger.loadDataHash

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
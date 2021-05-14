require_relative 'FileIO'
require 'json'

class JSONLogger
    #{
    # startProcess (key) : [{}...{}]
    # fileIO (key) : [{}...{}]
    # transferData (key) : [{}...{}]
    #}
    @JSONLogger = nil

    def self.getJSONLogger
        @JSONLogger = JSONLogger.new if @JSONLogger == nil
        return @JSONLogger
    end

    def loadDataHash
        file = File.read(@filePath)
        @data_hash = JSON.parse(file)
    end

    def addData key, value
        @data_hash[key] = [] if not @data_hash.has_key? key
        @data_hash[key].push(value)
    end

    def writeData
        File.write @filePath, JSON.pretty_generate(@data_hash)
    end

    private
    def initialize

        dirPath = FileIO.fixatePath(Dir.pwd)
        @currentDirPath = "#{dirPath}tools"
        @fileName = "JSONLogger.json"

        @filePath = "#{FileIO.fixatePath(@currentDirPath)}#{@fileName}"
        
        if not File::exists? (@filePath)
            File.new(@filePath, "w")
            File.write @filePath, "{\n}"
        end
        loadDataHash 
    end 
end
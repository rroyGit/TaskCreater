module OSFinder
    def OSFinder.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OSFinder.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OSFinder.linux?
        OSFinder.unix? and not OSFinder.mac?
    end

    def OSFinder.unix?
        !OSFinder.windows?
    end
end
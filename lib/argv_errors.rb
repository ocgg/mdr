module ArgvErrors
  def self.msg(str)
    "\e[31mArgument/option error:\n#{str}\e[0m"
  end

  class UnknownArg < StandardError
    def argv_msg = ArgvErrors.msg("unknown additionnal argument: #{message}")
  end

  class FileNotFound < StandardError
    def argv_msg = ArgvErrors.msg("file not found: #{message}")
  end

  class FileNotProvided < StandardError
    def argv_msg = ArgvErrors.msg("no file provided")
  end

  class CenterWithNoWidth < StandardError
    def argv_msg = ArgvErrors.msg("specify --width when using --center")
  end
end

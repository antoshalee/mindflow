require 'mindflow'
require 'listen'
require 'pathname'

module Mindflow
  class Cli
    InvalidFileExtension = Class.new(StandardError)

    def initialize(argv)
      @argv = argv
      check_args
    end

    def run
      generate
      listen
    end

    private

    ALLOWED_EXTNAME = '.mindflow'.freeze

    def check_args
      if ::File.extname(mindflow_filename) != ALLOWED_EXTNAME
        raise InvalidFileExtension, 'Invalid file extension for mindflow file'
      end
    end

    def mindflow_filename
      @argv[0]
    end

    def generate
      puts "Generate ruby files.."
      FileUtils.rm_rf output_dir
      Generator.new(path, root_dir: output_dir).generate
    rescue => ex
      puts ex.backtrace
    end

    def listen
      puts "Listen to #{path}"
      listener = Listen.to(dir, only: /\.mindflow$/) do
        generate
      end
      listener.start
      sleep
    end

    def path
      ::File.expand_path "#{dir}/#{mindflow_filename}"
    end

    def dir
      Dir.pwd
    end

    def output_dir
      "tmp/mindflow/#{mindflow_name}"
    end

    def mindflow_name
      ::File.basename(mindflow_filename, ".*")
    end
  end
end

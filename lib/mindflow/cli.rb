require 'mindflow'
require 'listen'
require 'pathname'

module Mindflow
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def run
      generate
      listen
    end

    private

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
      listener.start # not blocking
      sleep
    end

    def path
      ::File.expand_path "#{dir}/#{@argv[0]}"
    end

    def dir
      Dir.pwd
    end

    def output_dir
      "tmp/mindflow/#{mindflow_name}"
    end

    def mindflow_name
      ::File.basename(@argv[0], ".*")
    end
  end
end

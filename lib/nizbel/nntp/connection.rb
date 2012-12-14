require 'openssl'
require 'socket'

module Nizbel
  module Nntp

    class Connection
      def initialize(host, port, use_ssl)
        @socket = TCPSocket.new(host, port)

        if use_ssl
          @socket = OpenSSL::SSL::SSLSocket.new(@socket)
        end

        @peek = nil
      end

      def open
        @socket.connect
        parse_reply(@socket.gets.chomp)
      end

      def close
        @socket.close
      end

      def peek
        @peek ||= @socket.gets.chomp
      end

      def gets
        line = @peek || @socket.gets.chomp
        @peek = nil
        line
      end

      def puts(str)
        @socket.puts(str)
        parse_reply(@socket.gets.chomp)
      end

      private

      def parse_reply(msg)
        { :code => msg.slice(0..2).to_i, :message => msg.slice(4..-1) }
      end
    end

  end
end

require 'nizbel/nntp/connection'
require 'nizbel/nntp/reply_codes'
require 'nizbel/nntp/decoders/yenc_decoder'

module Nizbel
  module Nntp

    class Client
      attr_reader :connected, :authenticated, :current_group

      def initialize
        @conn = nil
        @connected = @authenticated = false
      end

      def connect(hostname, port, ssl = false)
        @conn = Connection.new(hostname, port.to_i, ssl)
        @connected = ReplyCodes.is_good?(@conn.open[:code])
      end

      def authenticate(user, pass)
        send_and_verify "AUTHINFO USER #{user}"
        send_and_verify "AUTHINFO PASS #{pass}"
        @authenticated = ReplyCodes.is_good?(set_mode('READER')[:code])
      end

      def close
        return nil unless connected
        result = @conn.puts('QUIT')
        @conn.close
        @connected = @authenticated = false
        result
      end

      def x_overview(range)
        # alt.binaries.erotica | 1906725665-1906725667
        raise Exception, 'You have to call set_group first.' unless @current_group.present?
        send_and_verify "XZVER #{range}"
        yenc = Nizbel::Nntp::Decoders::YencDecoder.new(@conn)
        data = yenc.decode
        raise Exception, 'Invalid CRC32' unless yenc.valid_crc32
        decompress(data).split("\r\n").map do |r|
          values = r.split("\t")
          Hash[(0..values.count-1).zip(values)]
        end
      end

      def set_group(group_name)
        send_and_verify("GROUP #{group_name}")
        @current_group = group_name
      end

      def date
        result = send_and_verify('DATE')
        Time.parse(result[:message]).utc
      end

      def article_exists?(article_id)
        result = @conn.puts("STAT <#{article_id}>")
        ReplyCodes.is_good?(result[:code])
      end

      private

      def decompress(data)
        zlib = Zlib::Inflate.new(-Zlib::MAX_WBITS)
        buf = zlib.inflate(data)
        zlib.finish
        zlib.close
        buf
      end

      def send_and_verify(command)
        result = @conn.puts(command)
        verify result
      end

      def verify(result)
        raise Exception, result[:message] unless ReplyCodes.is_good?(result[:code])
        result
      end

      def set_mode(mode)
        @conn.puts "MODE #{mode}"
      end
    end

  end
end
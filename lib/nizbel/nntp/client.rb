require 'nizbel/nntp/connection'
require 'nizbel/nntp/reply_codes'
require 'nizbel/nntp/decoders/yenc_decoder'

module Nizbel
  module Nntp

    class Client
      attr_reader :connected, :authenticated, :current_group, :overview_fields

      def initialize
        @conn = nil
        @connected = @authenticated = false
        @overview_fields = [:article_id]
      end

      def connect(hostname, port, ssl = false)
        @conn = Connection.new(hostname, port.to_i, ssl)
        @connected = ReplyCodes.is_good?(@conn.open[:code])
      end

      def authenticate(user, pass)
        send_and_verify "AUTHINFO USER #{user}"
        send_and_verify "AUTHINFO PASS #{pass}"
        set_mode 'READER'
        populate_overview_fields
        @authenticated = true
      end

      def close
        return nil unless @connected
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
          Hash[(0..values.count-1).map{ |i| @overview_fields[i] }.zip(values)]
        end.each do |o|
          o[:article_id] = o[:article_id].to_i
          o[:date] = Time.parse(o[:date]).utc
          o[:bytes] = o[:bytes].to_i
          o[:lines] = o[:lines].to_i
        end
      end

      def set_group(group_name)
        result = send_and_verify("GROUP #{group_name}")
        @current_group = group_name
        info = result[:message].split
        { :article_count => info[0].to_i, :first => info[1].to_i, :last => info[2].to_i, :group => info[3] }
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

      def populate_overview_fields
        send_and_verify "LIST OVERVIEW.FMT"
        while (line = @conn.gets) != '.'
          @overview_fields << line.split(':').find(&:present?).gsub('-', '_').downcase.to_sym
        end
      end

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
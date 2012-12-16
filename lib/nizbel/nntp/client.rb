require 'nizbel/nntp/connection'
require 'nizbel/nntp/reply_codes'
require 'nizbel/nntp/decoders/yenc_decoder'

module Nizbel
  module Nntp
    class NntpError < StandardError; end

    class Client
      attr_reader :connected, :authenticated, :group, :overview_fields

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
        require_group
        send_and_verify "XZVER #{range}"
        result = decode_connection_data

        decompress(result[:data]).split("\r\n").map do |r|
          values = r.split("\t")
          Hash[(0..values.count-1).map{ |i| @overview_fields[i] }.zip(values)]
        end.each(&method(:convert_values))
      end

      def x_header(header, range)
        require_group
        send_and_verify "XZHDR #{header} #{range}"
        result = decode_connection_data

        decompress(result[:data]).split("\r\n").map do |r|
          values = r.split(' ', 2)
          Hash[[:id, header.downcase.parameterize.to_sym].zip(values)]
        end.each(&method(:convert_values))
      end

      def set_group(group_name)
        result = send_and_verify("GROUP #{group_name}")
        @group = group_name
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
          @overview_fields << line.split(':').find(&:present?).downcase.parameterize.to_sym
        end
      end

      def decompress(data)
        zlib = Zlib::Inflate.new(-Zlib::MAX_WBITS)
        buf = zlib.inflate(data)
        zlib.finish
        zlib.close
        buf
      end

      def decode_connection_data
        decoded_result = Nizbel::Nntp::Decoders::YencDecoder.decode(@conn)
        raise NntpError, 'Invalid CRC32' unless decoded_result[:valid_crc32]
        decoded_result
      end

      def send_and_verify(command)
        result = @conn.puts(command)
        raise NntpError, result[:message] unless ReplyCodes.is_good?(result[:code])
        result
      end

      def require_group
        unless @group.present?
          raise NntpError, 'You have to call set_group with a newsgroup name before using this method.'
        end
      end

      def set_mode(mode)
        @conn.puts "MODE #{mode}"
      end

      def convert_values(hash)
        hash.tap do |h|
          [:article_id, :bytes, :lines].each do |k,v|
            h[k] = h[k].to_i if h.has_key?(k)
          end
          h[:date] = Time.parse(h[:date]).utc if h.has_key?(:date)
        end
      end
    end

  end
end

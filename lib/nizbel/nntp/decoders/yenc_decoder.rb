require 'stringio'
require 'zlib'

module Nizbel
  module Nntp
    module Decoders

      class YencDecoder
        attr_reader :headers, :valid_crc32, :complete

        def initialize(conn)
          raise ArgumentException 'Not a valid connection' unless conn.is_a?(Nizbel::Nntp::Connection)
          @conn = conn
          read_headers
          @complete = false
        end

        def decode
          return nil if @complete

          #data = ''.force_encoding('ASCII-8BIT')
          data = StringIO.new
          data.set_encoding('ASCII-8BIT')
          while !@conn.peek.include?('=yend')
            escape = false
            @conn.gets.each_byte do |b|
              next if b == 10 || b == 13
              if b == 61 && !escape
                escape = true
                next
              else
                if escape
                  escape = false
                  b = b - 64
                end
                decoded = b.between?(0, 41) ? (b + 214) : (b - 42)
                data.putc(decoded)
              end
            end
          end

          footer = parse_yenc(@conn.gets)
          crc_key = footer.keys.detect(/crc/).first

          @valid_crc32 = footer[crc_key] == Zlib.crc32(data.string, 0).to_s(16)
          @conn.gets # "."
          @complete = true
          data.string
        end

        private

        def read_headers
          if @conn.peek.include?('=ybegin')
            @headers = parse_yenc(@conn.gets)
          end
          if @conn.peek.include?('=ypart')
            @headers.merge(parse_yenc(@conn.gets))
          end
        end

        def parse_yenc(line)
          rx = /([A-z0-9]+)=(.*?)(?:\s|$)/
          Hash[line.scan(rx).map{|k,v|[k.to_sym,v]}]
        end
      end

    end
  end
end
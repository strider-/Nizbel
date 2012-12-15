require 'zlib'

module Nizbel
  module Nntp
    module Decoders

      class YencDecoder
        def self.decode(conn)
          raise ArgumentException 'Not a valid connection' unless conn.is_a?(Nizbel::Nntp::Connection)
          raise Nizbel::Nntp::NntpError 'Missing valid yEnc header' unless conn.peek.include?('=ybegin')

          headers = read_headers(conn)
          data = ''.force_encoding('ASCII-8BIT')
          while !conn.peek.include?('=yend')
            escape = false
            conn.gets.each_byte do |b|
              next if b == 0x0A || b == 0x0D
              if b == 0x3D && !escape
                escape = true
                next
              else
                if escape
                  escape = false
                  b = b - 0x40
                end
                decoded = b.between?(0x00, 0x29) ? (b + 0xD6) : (b - 0x2A)
                data << decoded
              end
            end
          end

          footer = parse_yenc(conn.gets)
          crc_key = footer.keys.detect(/crc/).first
          actual_crc32 = "%.8x" % Zlib.crc32(data, 0)
          conn.gets # "."

          { :headers => headers, :data => data, :valid_crc32 => footer[crc_key].casecmp(actual_crc32) == 0 }
        end

        private

        def self.read_headers(conn)
          headers = parse_yenc(conn.gets)
          headers.merge(parse_yenc(conn.gets)) if conn.peek.include?('=ypart')
          headers
        end

        def self.parse_yenc(line)
          rx = /([A-z0-9]+)=(.*?)(?:\s|$)/
          Hash[line.scan(rx).map{|k,v|[k.to_sym,v]}]
        end
      end

    end
  end
end
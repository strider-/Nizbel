require 'nizbel/nntp/client'

module Nizbel
  module Nntp

    class Scraper

      MAX_MESSAGES = 20000
      PART_REGEX = /\(((?<part_number>\d+))\/((?<total_parts>\d+))\)$/i

      def update_groups
        open_connection

        Group.active.each do |group|
          @current_group = group
          next if group.id == 1

          group_info = @client.set_group(group.name)
          last = group_info[:last]

          if group.last_record == 0
            article_range = @client.article_range_for(3.days.ago)
            first = article_range[:first]
            group.first_record_postdate = article_range[:first_date]
          else
            first = group.last_record + 1
            group.first_record_postdate = @client.x_header('date', first).first[:date]
          end
          group.first_record = first

          total = (last - first)
          group.active = total > 5

          ranges = []
          (first..last).step(MAX_MESSAGES) do |n|
            ranges << "#{n}-#{n + (MAX_MESSAGES - 1)}"
            ranges << "#{n + MAX_MESSAGES}-#{n + (last - n)}" if last - n < MAX_MESSAGES
          end

          ranges.each { |range| scan_group(range) }

          group.last_record = last
          group.last_record_postdate = @client.x_header('date', last).first[:date]
          group.last_updated = Time.now.utc
          group.save
          break
        end

        close_connection
      end

      private

      def scan_group(range)
        puts 'scanning group'
        bins = {}
        @client.x_overview(range).each do |overview|
          if match = overview[:subject].match(PART_REGEX)
            subject = overview[:subject].gsub(PART_REGEX, '').strip
            unless bins.has_key?(subject)
              bins.merge!(subject => {
                :total_parts => match['total_parts'].to_i,
                :poster => overview[:from],
                :date => overview[:date],
                :parts => []
              })
            end
            bins[subject][:parts] << {
              :part_number => match['part_number'].to_i,
              :message_id => overview[:message_id],
              :article_id => overview[:article_id],
              :size => overview[:bytes]
            }
          end
        end
        update_binaries(bins)
      end

      def update_binaries(binaries_hash)
        puts 'updating db'
        binaries_hash.each do |subject, data|
          b_hash = Digest::MD5.hexdigest("#{subject}#{data[:poster]}#{@current_group.id}")
          bin = Binary.where(:binary_hash => b_hash).first || Binary.new(:binary_hash => b_hash)
          if bin.new_record?
            bin.name = subject
            bin.poster = data[:poster]
            bin.total_parts = data[:total_parts]
            bin.date = data[:date]
            bin.group = @current_group
            bin.save
          end

          data[:parts].each do |part|
            bin_part = Part.new
            bin_part.binary = bin
            bin_part.update_attributes(part)
          end
        end
      end

      def open_connection
        config = Nizbel::Engine.config
        @client = Client.new
        @client.connect(config.host, config.port, config.ssl)
        @client.authenticate(config.username, config.password)
      end

      def close_connection
        @client.close
        @client = nil
      end
    end

  end
end
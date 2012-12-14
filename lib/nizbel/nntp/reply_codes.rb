module Nizbel
  module Nntp
    module ReplyCodes
      SERVER_READY_POSTING_ALLOWED = 200
      SERVER_READY_NO_POSTING = 201
      AUTHENTICATION_ACCEPTED_1 = 250
      AUTHENTICATION_ACCEPTED_2 = 281
      NEED_PASSWORD = 381
      PERMISSION_DENIED = 480
      BAD_COMMAND = 500

      class << self
        def is_good?(code)
          code.to_i > 100 && code.to_i < 400
        end

        def self.server_ready?(code)
          [SERVER_READY_POSTING_ALLOWED, SERVER_READY_NO_POSTING].include?(code.to_i)
        end

        def accepted?(code)
          [AUTHENTICATION_ACCEPTED_1, AUTHENTICATION_ACCEPTED_2].include?(code.to_i)
        end
      end
    end
  end
end
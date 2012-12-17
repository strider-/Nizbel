module Nizbel
  class Part < ActiveRecord::Base
    attr_accessible :article_id, :binary_id, :message_id, :part_number, :size

    belongs_to :binary, :dependent => :destroy
  end
end

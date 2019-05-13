module Grimonium::Crawlers
  class Base
    attr_reader :record

    def initialize(record)
      @record = record
      setup
    end

    def setup
    end

    def crawl
      raise NotImplementedError.new('crawl method is not implemented')
    end

    class << self
      def crawler_name(name = nil)
        if name.blank?
          @name = self.to_s.split('::').last.underscore if @name.blank?
          return @name
        end

        @name = name
      end
    end
  end
end

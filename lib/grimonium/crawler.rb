module Grimonium
  class Crawler
    class << self
      def by(name)
        load_crawler
        return @crawlers[name.to_s]
      end

      def exists?(name)
        !by(name).nil?
      end

      private

      def load_crawler
        return if @crawlers.present?

        @crawlers = {}
        crawlers1 = Dir.glob("#{Rails.root.join('lib', 'grimonium', 'crawlers')}/**/*.rb")
        crawlers2 = Dir.glob("#{Rails.root.join('lib', 'crawlers')}/**/*.rb")
        (crawlers1 + crawlers2).each do |file|
          require file
        end

        base_class = Grimonium::Crawlers::Base
        ObjectSpace.each_object(base_class.singleton_class).each do |klass|
          next if klass == base_class
          @crawlers[klass.crawler_name.to_s] = klass
        end
      end
    end
  end
end

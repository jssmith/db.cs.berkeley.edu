module FormatUtil
	include Liquid
    def makerows(input, num_across)
    	input.each_slice(to_number(num_across)).to_a
	end
	def name_sort(name)
		name.split(" ").reverse.join(" ").upcase
	end
    def sort_names(input, property = nil)
      ary = InputIterator.new(input)
      if property.nil?
        ary.sort { |a, b| name_sort(a) <=> name_sort(b) } 
      elsif ary.empty? # The next two cases assume a non-empty array.
        []
      elsif ary.first.respond_to?(:[]) && !ary.first[property].nil?
        ary.sort { |a, b| name_sort(a[property]) <=> name_sort(b[property]) }
      elsif ary.first.respond_to?(property)
        ary.sort { |a, b| name_sort(a.send(property)) <=> name_sort(b.send(property)) }
      end
    end

    class InputIterator
      include Enumerable

      def initialize(input)
        @input = if input.is_a?(Array)
          input.flatten
        elsif input.is_a?(Hash)
          [input]
        elsif input.is_a?(Enumerable)
          input
        else
          Array(input)
        end
      end

      def join(glue)
        to_a.join(glue)
      end

      def concat(args)
        to_a.concat args
      end

      def reverse
        reverse_each.to_a
      end

      def uniq(&block)
        to_a.uniq(&block)
      end

      def compact
        to_a.compact
      end

      def empty?
        @input.each { return false }
        true
      end

      def each
        @input.each do |e|
          yield(e.respond_to?(:to_liquid) ? e.to_liquid : e)
        end
      end
    end
end
Liquid::Template.register_filter(FormatUtil)
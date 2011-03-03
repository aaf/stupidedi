module Stupidedi
  module Schema

    class TableDef
      # @return [String]
      attr_reader :id

      # @return [Array<SegmentUse>]
      attr_reader :header_segment_uses

      # @return [Array<SegmentUse>]
      attr_reader :trailer_segment_uses

      # @return [Array<LoopDef>]
      attr_reader :loop_defs

      # @todo
      # @return [TransactionSetDef]
      attr_reader :parent

      def initialize(id, header_segment_uses, loop_defs, trailer_segment_uses)
        @id, @header_segment_uses, @loop_defs, @trailer_segment_uses =
          id, header_segment_uses, loop_defs, trailer_segment_uses

        @header_segment_uses  = @header_segment_uses.map{|x| x.copy(:parent => self) }
        @loop_defs            = @loop_defs.map{|x| x.copy(:parent => self) }
        @trailer_segment_uses = @trailer_segment_uses.map{|x| x.copy(:parent => self) }
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:header_segment_uses, @header_segment_uses),
          changes.fetch(:loop_defs, @loop_defs),
          changes.fetch(:trailer_segment_uses, @trailer_segment_uses)
      end

      # @private
      def pretty_print(q)
        q.text("TableDef[#{@id}]")
        q.group(2, "(", ")") do
          q.breakable ""
          @header_segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
          @loop_defs.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
          @trailer_segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

    class << TableDef
      def build(id, *children)
        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, header, loop_defs, trailer, nil)
      end
    end

  end
end
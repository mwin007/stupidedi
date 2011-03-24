module Stupidedi
  module Values

    #
    # @see X222.pdf B.1.1.3.12.2 Data Segment Groups
    #
    module SegmentValGroup

      # @return [SimpleElementDef, CompositeElementDef, LoopDef, SegmentDef, TableDef]
      abstract :definition

      # @return [Array<SegmentVal>]
      abstract :segment_vals

      def empty?
        segment_vals.all?(&:empty?)
      end

      # @return false
      def leaf?
        false
      end

      # @return [Array<SegmentVal>]
      def at(n)
        raise IndexError unless definition.nil? or defined_at?(n)

        case n
        when Symbol, String
          segment_vals.select{|s| s.definition.id == n.to_sym }
        when Integer
          # @todo s.segment_use
          segment_vals.select{|s| s.segment_use.position == n }
        when SegmentDef
          # @todo s.segment_use
          segment_vals.select{|s| s.segment_use.definition == n }
        end or []
      end

      def defined_at?(n)
        return nil if definition.nil?

        case n
        when Symbol, String
          definition.segment_uses.any?{|s| s.definition.id == n.to_sym }
        when Integer
          definition.segment_uses.any?{|s| s.position == n }
        when SegmentDef
          definition.segment_uses.any?{|s| s.definiton == n }
        else
          raise TypeError
        end
      end
    end

  end
end

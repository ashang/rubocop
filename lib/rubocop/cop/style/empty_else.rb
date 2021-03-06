# encoding: utf-8

module RuboCop
  module Cop
    module Style
      # Checks for empty else-clauses, possibly including comments and/or an
      # explicit `nil` depending on the EnforcedStyle.
      #
      # SupportedStyles:
      #
      # @example
      #   # good for all styles
      #   if condition
      #     statement
      #   else
      #     statement
      #   end
      #
      #   # good for all styles
      #   if condition
      #     statement
      #   end
      #
      # empty - warn only on empty else
      #   @example
      #   # bad
      #   if condition
      #     statement
      #   else
      #   end
      #
      #   # good
      #   if condition
      #     statement
      #   else
      #     nil
      #   end
      #
      # nil - warn on else with nil in it
      #   @example
      #   # bad
      #   if condition
      #     statement
      #   else
      #     nil
      #   end
      #
      #   # good
      #   if condition
      #     statement
      #   else
      #   end
      #
      # both - warn on empty else and else with nil in it
      #   @example
      #   # bad
      #   if condition
      #     statement
      #   else
      #     nil
      #   end
      #
      #   # bad
      #   if condition
      #     statement
      #   else
      #   end
      class EmptyElse < Cop
        include OnNormalIfUnless
        include ConfigurableEnforcedStyle

        MSG = 'Redundant `else`-clause.'

        def on_normal_if_unless(node)
          check(node, if_else_clause(node))
        end

        def on_case(node)
          check(node, case_else_clause(node))
        end

        private

        def check(node, else_clause)
          case style
          when :empty
            empty_check(node, else_clause)
          when :nil
            nil_check(node, else_clause)
          when :both
            both_check(node, else_clause)
          end
        end

        def empty_check(node, else_clause)
          add_offense(node, :else, MSG) if node.loc.else && else_clause.nil?
        end

        def nil_check(node, else_clause)
          return unless else_clause && else_clause.type == :nil
          add_offense(node, node.location, MSG)
        end

        def both_check(node, else_clause)
          return if node.loc.else.nil?

          if else_clause.nil?
            add_offense(node, :else, MSG)
          elsif else_clause.type == :nil
            add_offense(node, :else, MSG)
          end
        end
      end
    end
  end
end

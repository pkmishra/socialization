module ActiveRecord
  class Base
    def is_upvoteable?
      false
    end
    alias upvoteable? is_upvoteable?
  end
end

module Socialization
  module UpVoteable
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.upvote_model.remove_upvoters(self) }

      # Specifies if self can be upvoted.
      #
      # @return [Boolean]
      def is_upvoteable?
        true
      end
      alias upvoteable? is_upvoteable?

      # Specifies if self is upvoted by a {upvoter} object.
      #
      # @return [Boolean]
      def upvoted_by?(upvoter)
        raise Socialization::ArgumentError, "#{upvoter} is not upvoter!"  unless upvoter.respond_to?(:is_upvoter?) && upvoter.is_upvoter?
        Socialization.upvote_model.upvotes?(upvoter, self)
      end

      # Returns all upvoters liking self.
      #
      # @param [Class] klass the {upvoter} class to be included. e.g. `User`
      # @return [Array<upvoter, Numeric>] An array of upvoter objects or IDs
      def upvoters(klass, opts = {})
        Socialization.upvote_model.upvoters(self, klass, opts)
      end

      # Returns a scope of the {upvoter}s liking self.
      #
      # @param [Class] klass the {upvoter} class to be included in the scope. e.g. `User`
      # @return ActiveRecord::Relation
      def upvoters_relation(klass, opts = {})
        Socialization.upvote_model.upvoters_relation(self, klass, opts)
      end

    end
  end
end


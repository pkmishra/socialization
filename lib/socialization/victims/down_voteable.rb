module ActiveRecord
  class Base
    def is_downvoteable?
      false
    end
    alias downvoteable? is_downvoteable?
  end
end

module Socialization
  module DownVoteable
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.downvote_model.remove_downvoters(self) }

      # Specifies if self can be downvoted.
      #
      # @return [Boolean]
      def is_downvoteable?
        true
      end
      alias downvoteable? is_downvoteable?

      # Specifies if self is downvoted by a {downvoter} object.
      #
      # @return [Boolean]
      def downvoted_by?(downvoter)
        raise Socialization::ArgumentError, "#{downvoter} is not downvoter!"  unless downvoter.respond_to?(:is_downvoter?) && downvoter.is_downvoter?
        Socialization.downvote_model.downvotes?(downvoter, self)
      end

      # Returns all downvoters liking self.
      #
      # @param [Class] klass the {downvoter} class to be included. e.g. `User`
      # @return [Array<downvoter, Numeric>] An array of downvoter objects or IDs
      def downvoters(klass, opts = {})
        Socialization.downvote_model.downvoters(self, klass, opts)
      end

      # Returns a scope of the {downvoter}s liking self.
      #
      # @param [Class] klass the {downvoter} class to be included in the scope. e.g. `User`
      # @return ActiveRecord::Relation
      def downvoters_relation(klass, opts = {})
        Socialization.downvote_model.downvoters_relation(self, klass, opts)
      end

    end
  end
end


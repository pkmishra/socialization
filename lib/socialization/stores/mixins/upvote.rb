module Socialization
  module Stores
    module Mixins
      module UpVote

      public
        def touch(what = nil)
          if what.nil?
            @touch || false
          else
            raise Socialization::ArgumentError unless [:all, :upvoter, :upvoteable, false, nil].include?(what)
            @touch = what
          end
        end

        def after_upvote(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_create_hook = method
        end

        def after_unupvote(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_destroy_hook = method
        end

      protected
        def call_after_create_hooks(upvoter, upvoteable)
          self.send(@after_create_hook, upvoter, upvoteable) if @after_create_hook
          touch_dependents(upvoter, upvoteable)
        end

        def call_after_destroy_hooks(upvoter, upvoteable)
          self.send(@after_destroy_hook, upvoter, upvoteable) if @after_destroy_hook
          touch_dependents(upvoter, upvoteable)
        end

      end
    end
  end
end


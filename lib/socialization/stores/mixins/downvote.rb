module Socialization
  module Stores
    module Mixins
      module DownVote

      public
        def touch(what = nil)
          if what.nil?
            @touch || false
          else
            raise Socialization::ArgumentError unless [:all, :downvoter, :downvoteable, false, nil].include?(what)
            @touch = what
          end
        end

        def after_downvote(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_create_hook = method
        end

        def after_undownvote(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_destroy_hook = method
        end

      protected
        def call_after_create_hooks(downvoter, downvoteable)
          self.send(@after_create_hook, downvoter, downvoteable) if @after_create_hook
          touch_dependents(downvoter, downvoteable)
        end

        def call_after_destroy_hooks(downvoter, downvoteable)
          self.send(@after_destroy_hook, downvoter, downvoteable) if @after_destroy_hook
          touch_dependents(downvoter, downvoteable)
        end

      end
    end
  end
end


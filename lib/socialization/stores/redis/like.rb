module Socialization
  module RedisStores
    class Like < Socialization::RedisStores::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::Like
      extend Socialization::RedisStores::Mixins::Base

      class << self
        alias_method :like!, :relation!;                          public :like!
        alias_method :unlike!, :unrelation!;                      public :unlike!
        alias_method :likes?, :relation?;                         public :likes?
        alias_method :likers, :actors;                            public :likers
        alias_method :likeables, :victims;                        public :likeables
        alias_method :remove_likers, :remove_actor_relations;     public :remove_likers
        alias_method :remove_likeables, :remove_victim_relations; public :remove_likeables
        alias_method :like_time, :score;                          public :like_time
      end

    end
  end
end

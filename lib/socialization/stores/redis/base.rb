module Socialization
  module RedisStores
    class Base

      class << self
        protected
        def actors(victim, klass, options = {})
          Socialization.redis.zrevrange(generate_forward_key(victim), 0, -1).inject([]) do |result, element|
            result << element.match(/\:(\d+)$/)[1] if element.match(/^#{klass}\:/)
            result
          end
        end


        def victims(actor, klass, options = {})
          Socialization.redis.zrevrange(generate_backward_key(actor), 0, -1).inject([]) do |result, element|
            result << element.match(/\:(\d+)$/)[1] if element.match(/^#{klass}\:/)
            result
          end
        end
        def relation!(actor, victim, options = {})
          unless options[:skip_check] || relation?(actor, victim)
            Socialization.redis.zadd generate_forward_key(victim), Time.now.to_i, generate_redis_value(actor)
            Socialization.redis.zadd generate_backward_key(actor), Time.now.to_i, generate_redis_value(victim)
            call_after_create_hooks(actor, victim)
            true
          else
            false
          end
        end

        def unrelation!(actor, victim, options = {})
          if options[:skip_check] || relation?(actor, victim)
            Socialization.redis.zrem generate_forward_key(victim), generate_redis_value(actor)
            Socialization.redis.zrem generate_backward_key(actor), generate_redis_value(victim)
            call_after_destroy_hooks(actor, victim)
            true
          else
            false
          end
        end

        def relation?(actor, victim)
          !Socialization.redis.zrevrank(generate_forward_key(victim), generate_redis_value(actor)).nil?
        end

        def score(victim, actor)
          Socialization.redis.zscore generate_forward_key(victim),  generate_redis_value(actor) 
        end

        def remove_actor_relations(victim)
          forward_key = generate_forward_key(victim)
          actors = Socialization.redis.zrevrange forward_key, 0, -1
          Socialization.redis.del forward_key
          actors.each do |actor|
            Socialization.redis.zrem generate_backward_key(actor), generate_redis_value(victim)
          end
          true
        end

        def remove_victim_relations(actor)
          backward_key = generate_backward_key(actor)
          victims = Socialization.redis.zrevrange backward_key, 0, -1
          Socialization.redis.del backward_key
          victims.each do |victim|
            Socialization.redis.zrem generate_forward_key(victim), generate_redis_value(actor)
          end
          true
        end


        private
        def key_type_to_type_names(klass)
          if klass.name.match(/Follow$/)
            ['follower', 'followable']
          elsif klass.name.match(/Like$/)
            ['liker', 'likeable']
          elsif klass.name.match(/Mention$/)
            ['mentioner', 'mentionable']
          elsif klass.name.match(/UpVote$/)
            ['upvoter', 'upvoteable']
          elsif klass.name.match(/DownVote$/)
            ['downvoter', 'downvoteable']
          else
            raise Socialization::ArgumentError.new("Can't find matching type for #{klass}.")
          end
        end

        def generate_forward_key(victim)
          keys = key_type_to_type_names(self)
          if victim.is_a?(String)
            "#{keys[0].pluralize.capitalize}:#{victim}"
          else
            "#{keys[0].pluralize.capitalize}:#{victim.class}:#{victim.id}"
          end
        end

        def generate_backward_key(actor)
          keys = key_type_to_type_names(self)
          if actor.is_a?(String)
            "#{keys[1].pluralize.capitalize}:#{actor}"
          else
            "#{keys[1].pluralize.capitalize}:#{actor.class}:#{actor.id}"
          end
        end

        def generate_redis_value(obj)
          "#{obj.class.name}:#{obj.id}"
        end

      end # class << self

    end # Base
  end # RedisStores
end # Socialization

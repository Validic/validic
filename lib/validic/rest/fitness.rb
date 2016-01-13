require 'validic/fitness'

module Validic
  module REST
    module Fitness

      def get_fitness(options = {})
        overwrite_creds(options)
        resp = get_request(:fitness, options)
        build_response_attr(resp)
      end
      alias :get_fitnesses :get_fitness

      def create_fitness(options = {})
        overwrite_creds(options)
        user_id = options.delete(:user_id)
        options = { user_id: user_id, fitness: options }
        response = post_request(:fitness, options)
        Validic::Fitness.new(response['fitness'])
      end

      def update_fitness(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id, fitness: options }
        response = put_request(:fitness, options)
        Validic::Fitness.new(response['fitness'])
      end

      def delete_fitness(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id }
        delete_request(:fitness, options)
        true
      end

      def latest_fitness(options = {})
        overwrite_creds(options)
        resp = latest(:fitness, options)
        build_response_attr(resp)
      end
    end
  end
end

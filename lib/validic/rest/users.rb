require 'validic/user'

module Validic
  module REST
    module Users

      def get_users(options = {})
        overwrite_creds(options)
        resp = get_request(:users, options)
        build_response_attr(resp)
      end
      alias :get_user :get_users

      def refresh_token(options = {})
        overwrite_creds(options)
        response = get_request(:refresh_token, options)
        Validic::User.new(response['user'])
      end

      def me(options = {})
        overwrite_creds(options)
        response = get_request(:me, options)
        response['me']['_id']
      end

      def provision_user(options = {})
        overwrite_creds(options)
        response = post_request(:users, { user: options })
        Validic::User.new(response['user'])
      end
      alias :user_provision :provision_user

      def update_user(options = {})
        overwrite_creds(options)
        user_id = options.delete(:user_id)
        response = put_request(:users, { user_id: user_id, user: options })
        Validic::User.new(response['user'])
      end
      alias :user_update :update_user

      def delete_user(options = {})
        overwrite_creds(options)
        delete_request(:users, { user_id: options[:user_id] })
        true
      end
      alias :user_delete :delete_user

      def suspend_user(options = {})
        overwrite_creds(options)
        put_request(:users, { user_id: options[:user_id], suspend: '1' })
        true
      end
      alias :user_suspend :suspend_user

      def unsuspend_user(options = {})
        overwrite_creds(options)
        put_request(:users, { user_id: options[:user_id], suspend: '0' })
        true
      end
      alias :user_unsuspend :unsuspend_user
    end
  end
end

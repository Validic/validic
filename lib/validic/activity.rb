# encoding: utf-8

module Validic
  module Activity

    ##
    # Get Activity base on `access_token`
    # Default data fetched is from yesterday
    #
    # @params :organization_id - for organization specific activity
    # @params :user_id - for user specific activity
    #
    # @params :start_date - optional
    # @params :end_date - optional
    # @params :access_token - override for default access_token
    # @params :page
    # @params :limit
    # @params :offset
    # 
    # @return [Hashie::Mash] with list of Activity
    def get_activities(options={})
      organization_id = options[:organization_id] || Validic.organization_id
      user_id = options[:user_id]
      options = {
        access_token: options[:access_token],
        start_date: options[:start_date],
        end_date: options[:end_date],
        limit: options[:limit],
        page: options[:page],
        offset: options[:offset],
        expanded: options[:expanded]
      }

      if organization_id
        response = get("/#{Validic.api_version}/organizations/#{organization_id}/fitness.json", options)
      elsif user_id
        response = get("/#{Validic.api_version}/users/#{user_id}/fitness.json", options)
      else
        response = get("/#{Validic.api_version}/fitness.json", options)
      end
      
      response if response
    end

    ##
    # Get the latest Activities base on 'access_token'
    # for organization or for a specific user
    #
    # @activity_type - mandatory - specify what type of activity to fetch
    # List of activity_types
    # [ fitness, routine, weight, nutrition, sleep, diabetes, biometrics, tobacco_cessation ]
    #
    # @params :organization_id - optional - supply only this to get all user's activities belonging to organization
    # @params :user_id - optional - supply only this to get the user's latest activities
    def get_latest_activities(options={})
      activity_type = options[:activity_type]
      organization_id = options[:organization_id]
      user_id = options[:user_id]
      options = {
        access_token: options[:access_token]
      }

      if activity_type.blank?
        response = "Invalid api request. params[:activity_type] can't be blank."
      else
        if organization_id && user_id
          response = get("/#{Validic.api_version}/organizations/#{organization_id}/users/#{user_id}/#{activity_type}/latest", options)
        elsif organization_id && user_id.blank?
          response = get("/#{Validic.api_version}/organizations/#{organization_id}/#{activity_type}/latest", options)
        elsif user_id && organization_id.blank?
          response = get("/#{Validic.api_version}/users/#{user_id}/#{activity_type}/latest", options)
        else
          response = get("/#{Validic.api_version}/#{activity_type}/latest", options)
        end
      end
      response if response
    end

  end
end

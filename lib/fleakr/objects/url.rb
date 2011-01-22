module Fleakr
  module Objects

    class Url

      def initialize(url)
        @url = url
      end

      def path
        expanded_path || original_path
      end

      def user_identifier
        (resource_type == Set) ? parts[1] : parts[2]
      end

      def shortened?
        !original_path.match(%r{^/p/[123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ]+$}).nil?
      end

      def resource_identifier
        parts[3]
      end

      def user
        @user ||= User.find_by_url(@url)
      end

      def resource_type
        if parts[1] == 'people'
          User
        elsif parts[1] == 'photos'
          Photo
        elsif parts[2] == 'sets'
          Set
        end
      end

      def collection?
        resource_identifier.nil?
      end

      def resource
        if resource_type == User
          user
        else
          collection? ? resource_type.find_all_by_user_id(user.id) : resource_type.find_by_id(resource_identifier)
        end
      end

      private

      def expanded_path
        Fleakr::Support::UrlExpander.expand(@url) if shortened?
      end

      def original_path
        URI.parse(@url).path
      end

      def parts
        path.match(matching_pattern)
      end

      def matching_pattern
        @matching_pattern ||= patterns.detect {|p| path.match(p) }
      end

      def patterns
        [
          %r{^/photos/([^/]+)/(sets)/(\d+)},
          %r{^/photos/([^/]+)/(sets)},
          %r{^/(photos)/([^/]+)/(\d+)},
          %r{^/(people)/([^/]+)},
          %r{^/(photos)/([^/]+)}
        ]
      end

    end

  end
end
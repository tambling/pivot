module Pivot
  module Pivotal
    # Abstracts a Pivotal Tracker project (which in turn contains stories).
    class Project < Base
      class << self
        def get_all
          client.get_projects.map do |api_project|
            from_api_project(api_project)
          end
        end

        # Gets by identifer, whether it's an ID or a name.
        def get(identifier)
          if identifier !~ /\D/
            get_by_id(identifier)
          else
            get_by_name(identifier)
          end
        end

        # Gets a project by numeric ID.
        def get_by_id(id)
          api_project = client.get_project(id)

          from_api_project(api_project)
        end

        # Because Pivotal Tracker doesn't support searching projects by name, we
        # have to get them all and filter locally if we want to search by name.
        def get_by_name(name)
          get_all.find { |project| project.name == name }
        end

        def from_api_project(api_project)
          id = api_project['id']
          name = api_project['name']

          new(id: id, name: name)
        end
      end

      attr_reader :id, :name

      def initialize(id:, name:)
        @id = id
        @name = name
      end

      def stories
        Story.get_by_project_id @id
      end
    end
  end
end

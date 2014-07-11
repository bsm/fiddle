module Shoulda # :nodoc:
  module Matchers
    module ActionController # :nodoc:
      # Ensures that filter_parameter_logging is set for the specified key.
      #
      # Example:
      #
      #   it { should permit_params(:attr1, :attr2) }
      #   it { should permit_params(:attr1, :attr2).for(:post) }
      def permit_params(*expected)
        PermitParamsMatcher.new(*expected)
      end

      class PermitParamsMatcher # :nodoc:

        def initialize(*expected)
          @expected = expected
        end

        def for(scope)
          @scope = scope
          self
        end

        def matches?(controller)
          @scope ||= determine_scope(controller)
          @permitted = controller.send(:permitted_params)[@scope] || {}

          match_nested?(@expected, @permitted, [@scope])
        end

        def failure_message
          "Expected #{@last_expectation}; permitted were: #{@permitted.inspect}"
        end

        def failure_message_when_negated
          "Did not expect #{@last_expectation}; permitted were: #{@permitted.inspect}"
        end

        def description
          "params #{@expected.inspect}"
        end

        private

          def tracking(truth, scope, attr, message = nil)
            suffix = (scope + [attr]).map {|k| "[:#{k}]" }.join
            @last_expectation = ["params#{suffix}", message].compact.join(" ")
            truth
          end

          def determine_scope(controller)
            if defined?(InheritedResources) && controller.is_a?(InheritedResources::Base)
              controller.send(:resource_instance_name)
            else
              controller.controller_name.singularize
            end
          end

          def match_nested?(expected, permitted, scope)
            expected.all? do |attr|
              case attr
              when Hash
                match_hash?(attr, permitted, scope)
              else
                ok = tracking permitted.key?(attr), scope, attr
                ok && tracking(!permitted[attr].is_a?(Enumerable), scope, attr, "to be a plain value")
              end
            end
          end

          def match_hash?(expected, permitted, scope)
            expected.all? do |attr, value|
              ok = tracking permitted.key?(attr), scope, attr
              ok && match_value?(value, permitted, attr, scope)
            end
          end

          def match_value?(expected, permitted, attr, scope)
            actual = permitted[attr]
            if expected.is_a?(Array) && expected.empty?
              tracking actual.is_a?(Array), scope, attr, "to be an Array"
            elsif expected.is_a?(Array)
              ok = tracking actual.is_a?(Hash), scope, attr, "to be a Hash"
              ok && match_nested?(expected, actual, scope + [attr])
            elsif expected.is_a?(Hash)
              ok = tracking actual.is_a?(Hash), scope, attr, "to be a Hash"
              ok && match_hash?(expected, actual, scope + [attr])
            else
              tracking false, scope, attr, "to be an Enumerable"
            end
          end
      end
    end
  end
end
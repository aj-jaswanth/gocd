##########################################################################
# Copyright 2015 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

module ApiV1
  module Config
    class ArtifactRepresenter < ApiV1::BaseRepresenter
      alias_method :artifact, :represented

      ARTIFACT_TYPE_TO_STRING_TYPE_MAP = {
        ArtifactType::unit => 'test',
        ArtifactType::file => 'build'
      }

      ARTIFACT_TYPE_TO_ARTIFACT_CLASS_MAP = {
        'test'  => TestArtifactPlan,
        'build' => ArtifactPlan
      }

      property :src, as: :source
      property :dest, as: :destination
      property :type, exec_context: :decorator, skip_parse: true
      property :errors, exec_context: :decorator, decorator: ApiV1::Config::ErrorRepresenter, skip_parse: true, skip_render: lambda { |object, options| object.empty? }

      def type
        ARTIFACT_TYPE_TO_STRING_TYPE_MAP[artifact.getArtifactType]
      end

      def errors
        mapped_errors = artifact.errors

        if src_errors = mapped_errors.delete('src')
          mapped_errors['source'] = src_errors
        end

        if dest_errors = mapped_errors.delete('dest')
          mapped_errors['destination'] = dest_errors
        end

        mapped_errors
      end

      class << self
        def get_class_for_artifact_type(type)
          ARTIFACT_TYPE_TO_ARTIFACT_CLASS_MAP[type] || (raise ApiV1::UnprocessableEntity, "Invalid Artifact type: '#{type}'. It has to be one of #{ARTIFACT_TYPE_TO_ARTIFACT_CLASS_MAP.keys.join(', ')}")
        end
      end
    end
  end
end
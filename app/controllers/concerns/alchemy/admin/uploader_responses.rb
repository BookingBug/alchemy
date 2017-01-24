module Alchemy
  module Admin
    module UploaderResponses
      extend ActiveSupport::Concern

      def succesful_uploader_response(file:)
        message = Alchemy.t(:upload_success,
          scope: [:uploader, file.class.model_name.i18n_key],
          name: file.name
        )

        {
          json: uploader_response(file: file, message: message),
          status: :created
        }
      end

      def failed_uploader_response(file:)
        message = Alchemy.t(:upload_failure,
          scope: [:uploader, file.class.model_name.i18n_key],
          error: file.errors[:file].join,
          name: file.name
        )

        {
          json: uploader_response(file: file, message: message),
          status: :unprocessable_entity
        }
      end

      private

      def uploader_response(file:, message:)
        {
          files: [file.to_jq_upload],
          growl_message: message
        }
      end
    end
  end
end

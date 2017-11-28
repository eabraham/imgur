module Imgurapi
  module Api
    class Image < Base

      # https://api.imgur.com/endpoints/image#image
      def image(id)
        raise 'Please provide a valid image identificator' if id.nil? || !id.is_a?(String) || id == '' || !!(id =~ /[^\w]/)

        Imgurapi::Image.new communication.call(:get, "image/#{id}")
      end

      # https://api.imgur.com/endpoints/image#image-upload
      def image_upload(local_file, optional_params: optional_params)
        optional_params ||= {}
      	file_type = FileType.new(local_file)

        image = if file_type.url?
                  local_file
                else
                  raise 'File must be an image' unless file_type.image?

                  file = local_file.respond_to?(:read) ? local_file : File.open(local_file, 'rb')

                  Base64.encode64(file.read)
                end
        payload = { image: image }.merge(optional_params)
        Imgurapi::Image.new communication.call(:post, 'image', payload)
      end

      # https://api.imgur.com/endpoints/image#image-delete
      def image_delete(id)
        if id.kind_of? Imgurapi::Image
          id = id.id
        end

        raise 'Please provide a valid image identificator' if id.nil? || !id.is_a?(String) || id == '' || !!(id =~ /[^\w]/)

        communication.call(:delete, "image/#{id}")
      end

      def image_to_gallery(id, optional_params: optional_params)
	optional_params ||= {}

	raise 'Invalid image id type. Must be a string.' if id.nil? || !id.is_a?(String) || id == '' || !!(id =~ /[^\w]/)

        communication.call(:post, "gallery/image/#{id}}", optional_params)      
      end
    end
  end
end

require 'aws-sdk-s3'

module Martilla
  class S3 < Storage
    def persist(tmp_file:, gzip:)
      path = output_filename(gzip)
      obj = s3_resource.bucket(bucket_name).object(path)

      # Upload it
      return nil if obj.upload_file(tmp_file)
      raise Error.new('Error uploading backup to bucket')
    end

    private

    def s3_resource
      options = {}
      options[:region] = aws_region unless aws_region.nil?
      options[:access_key_id] = aws_access_key unless aws_access_key.nil?
      options[:secret_access_key] = aws_secret_key unless aws_secret_key.nil?
      Aws::S3::Resource.new(options)
    end

    def aws_region
      @options['region']
    end

    def aws_access_key
      @options['access_key_id']
    end

    def aws_secret_key
      @options['secret_access_key']
    end

    def bucket_name
      bucket = @options['bucket']
      raise config_error('bucket') if bucket.nil?
      bucket
    end
  end
end

require "aws-sdk"

class Uploader
  def initialize(filename)
    @filename = filename
    init_service
  end

  def upload
    puts "Uploading #{@filename} to #{ENV["AWS_S3_BUCKET"]}..."
    @s3.buckets[ENV["AWS_S3_BUCKET"]].objects[key].write(file: @filename)
    puts "Finished uploading #{@filename}"
  rescue Exception => e
    puts "Error uploading #{@filename}: #{e.inspect}"
  end

  private
  def stream_id
    @filename.match(/\d+/).to_s
  end

  def key
    File.basename(@filename)
  end

  def init_service
    AWS.config(
      :access_key_id     => ENV["AWS_KEY_ID"],
      :secret_access_key => ENV["AWS_ACCESS_KEY"]
    )
    @s3 = AWS::S3.new
  end
end

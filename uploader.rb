require "aws-sdk"

class Uploader
  def initialize(filename)
    @filename = filename
    init_service
  end

  def upload
    puts "Uploading #{@filename} to #{ENV["AWS_S3_BUCKET"]}..."
    @uploaded_file = @s3.buckets[ENV["AWS_S3_BUCKET"]].objects[key].write(file: @filename)
    puts "Finished uploading #{@filename}"
    return true
  rescue Exception => e
    puts "Error uploading #{@filename}: #{e.inspect}"
    return false
  end

  def notify_api
    uri = URI.parse(ENV["API_HOST"])
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Get.new("/api/streams.json?stream_id=#{stream_id}")
    stream = JSON.parse(http.request(request).body)

    if stream.empty?
      puts "#{stream_id} not found on API"
    else
      request = Net::HTTP::Put.new("/api/streams/#{stream[0]["id"]}.json?auth_token=#{ENV["AUTH_TOKEN"]}")
      request.set_form_data({archived_url: @uploaded_file.public_url })
      http.request(request)
    end

   rescue Exception => e
     puts "Cannot connect to #{http.to_s}: #{e.inspect}"
  end

  private
  def stream_id
    @filename.match(/\d+/).to_s
  end

  # returns the key name for the new resource on S3
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

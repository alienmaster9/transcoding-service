class Transcoder
  @@videos = []
  def initialize(filename, directory)
    @filename = filename
    @directory = directory
  end

  def process
    @@videos << @filename
    puts "Starting transcoding..."
    new_file = transcode
    puts "Finished transcoding."
    @@videos.delete(@filename)
    new_file
  end


  private

  def transcode
    puts "Converting #{input_file}"
    system("ffmpeg -i #{input_file} -f webm -codec:v copy -codec:a vorbis -ac 2 -strict -2 #{output_file}")
    puts "Removing #{input_file}..."
    system("rm #{input_file}")
    output_file
  end

  def input_file
    "#{@directory}/#{@filename}"
  end

  def output_file
    "#{@directory}/#{@filename.split(".").first}.webm"
  end

  def already_processing?
    @@videos.include?(@filename)
  end
end

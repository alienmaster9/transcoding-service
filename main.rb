require "rb-inotify"
require "./transcoder.rb"
require "./uploader.rb"

VIDEO_DIRECTORY = ENV["VIDEO_DIRECTORY"]

puts "Starting video watcher.."
#Process.daemon

notifier = INotify::Notifier.new

notifier.watch(VIDEO_DIRECTORY, :close_write) do |event|

  if event.name =~ /mkv$/

    puts "#{Time.now}: Processing #{event.name}"

    transcoder = Transcoder.new(event.name, VIDEO_DIRECTORY)
    new_file = transcoder.process

    uploader = Uploader.new(new_file)
    if uploader.upload
      puts "Notifying API for stream_id #{uploader.stream_id}"
      uploader.notify_api
      system("rm #{new_file}")
    else
      puts "The file was not uploaded #{new_file}"
    end

  end

end

notifier.run

require "rb-inotify"
require "./transcoder.rb"
require "./uploader.rb"

VIDEO_DIRECTORY = "/home/emilio/videos"

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
      uploader.notify_api
      system("rm #{new_file}")
    end

  end

end

notifier.run

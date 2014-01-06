require "rb-inotify"
require "./transcoder.rb"
require "./uploader.rb"

VIDEO_DIRECTORY = "/home/emilio/videos"

puts "Starting video watcher.."
#Process.daemon

notifier = INotify::Notifier.new

i = 1
notifier.watch(VIDEO_DIRECTORY, :close_write) do |event|
  if event.name =~ /mkv$/
    puts "#{i}: Processing #{event.name}"
    transcoder = Transcoder.new(event.name, VIDEO_DIRECTORY)
    new_file = transcoder.process
    Uploader.new(new_file).upload
    i += 1
  end
end

notifier.run

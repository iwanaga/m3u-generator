require 'rubygems'
require 'audioinfo'
require 'find'

absolute_path_prefix = '/Volumes/share/music/'
relative_path_prefix = './'

def should_ignore?(file_path)
  return true if File.directory? file_path
  return true if file_path.rpartition('/').last.start_with?('.')
  return true if file_path.end_with?('.wav') # AudioInfo の返す曲の長さが明らかにおかしい
  return true if file_path.end_with?('.m3u')
  false
end

list = []
Find.find(absolute_path_prefix) do |f|
  next if should_ignore? f
  list << f
end

puts '#EXTM3U'
list.each do |music_file|
  AudioInfo.open(music_file) do |info|
    puts "#EXTINF:#{info.length},#{info.artist} - #{info.title}"
    puts music_file.gsub(absolute_path_prefix, relative_path_prefix)
  end
end

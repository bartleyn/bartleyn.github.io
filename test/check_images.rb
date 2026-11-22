# Fails if an image's contents don't match its file extension.
# Jekyll's ImageMagick step logs these as errors but still exits 0,
# so the responsive versions are silently missing from the site.
# Usage: ruby test/check_images.rb [dir]

MAGIC = {
  ".jpg" => ["\xFF\xD8".b],
  ".jpeg" => ["\xFF\xD8".b],
  ".png" => ["\x89PNG".b],
  ".gif" => ["GIF8".b],
  ".webp" => ["RIFF".b],
}.freeze

dir = ARGV[0] || "assets/img"
files = Dir.glob(File.join(dir, "**", "*")).select { |f| MAGIC.key?(File.extname(f).downcase) }
bad = files.reject do |f|
  head = File.binread(f, 4) || ""
  MAGIC[File.extname(f).downcase].any? { |m| head.start_with?(m) }
end

bad.each { |f| puts "BAD IMAGE #{f}: contents are not #{File.extname(f)} (starts with #{File.binread(f, 12).inspect})" }
puts "checked #{files.size} images, #{bad.size} bad"
exit(bad.empty? ? 0 : 1)

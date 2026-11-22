# Fails if a built page links to a file that isn't in the built site.
# Offline only: external links are too flaky to block a deploy on.
# Usage: bundle exec ruby test/check_links.rb [site_dir]
require "nokogiri"
require "uri"

site = File.expand_path(ARGV[0] || "_site")
abort "no built site at #{site}; run the build first" unless File.directory?(site)

# Matches names exactly, so a case mismatch fails here as it does on the
# (case-sensitive) live server, even on a case-insensitive Mac.
def exact_file?(site, path)
  return false unless path.start_with?("#{site}/")
  dir = site
  path.delete_prefix("#{site}/").split("/").reject(&:empty?).each do |name|
    return false unless File.directory?(dir) && Dir.children(dir).include?(name)
    dir = File.join(dir, name)
  end
  File.file?(dir)
end

def target_exists?(site, path)
  [path, File.join(path, "index.html"), "#{path}.html"].any? { |p| exact_file?(site, p) }
end

pages = Dir.glob(File.join(site, "**", "*.html"))
broken = Hash.new { |h, k| h[k] = [] }

pages.each do |page|
  doc = Nokogiri::HTML(File.read(page))
  refs = doc.css("[href]").map { |n| n["href"] } +
         doc.css("[src]").map { |n| n["src"] } +
         doc.css("[srcset]").flat_map { |n| n["srcset"].split(",").map { |s| s.strip.split(/\s+/).first } }
  refs.compact.map(&:strip).uniq.each do |ref|
    next if ref.empty? || ref.start_with?("#", "//") || ref.match?(/\A[a-z][a-z0-9+.-]*:/i)
    path = URI.decode_www_form_component(ref.sub(/[?#].*/m, "").gsub("+", "%2B"))
    next if path.empty?
    full = path.start_with?("/") ? File.join(site, path) : File.expand_path(path, File.dirname(page))
    broken[page.delete_prefix("#{site}/")] << ref unless target_exists?(site, full)
  end
end

broken.each { |page, refs| refs.each { |r| puts "BROKEN LINK in #{page}: #{r}" } }
puts "checked #{pages.size} pages, #{broken.values.sum(&:size)} broken links"
exit(broken.empty? ? 0 : 1)

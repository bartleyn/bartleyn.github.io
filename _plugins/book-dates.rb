# Dates each book by its `finished` front matter. Without this, books have no
# date, Jekyll gives them the build time, and the /books/<year>/ archive pages
# only exist for the current year. Runs before jekyll-archives-v2 groups by date.
class BookDates < Jekyll::Generator
  priority :highest

  def generate(site)
    site.collections["books"]&.docs&.each do |doc|
      finished = doc.data["finished"]
      doc.data["date"] = Jekyll::Utils.parse_date(finished.to_s) if finished
    end
  end
end

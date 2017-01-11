class HtmlLoader

  def initialize(file_location)
    @file_location = file_location
  end

  def load
    str = ""
    file_lines = File.readlines(@file_location)
    file_lines.each do |line|
      str += line.strip
    end
    str
  end

end
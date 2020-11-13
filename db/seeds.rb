require "csv"

def image_exist?(image_name, table_name: nil, extension: ".jpg")
    table_name ||= @table_name

    path = Rails.root.join("db/seeds/", @environment, "images", table_name, image_name + extension)
    if File.exist?(path)
        path
    else
        false
    end
end

table_names = %w(users categories tags notes my_lists)

# ファイルの読み込み
table_names.each do |table_name|
  @environment = (Rails.env == "test") ? "development" : Rails.env
  @table_name = table_name
	path = Rails.root.join("db/seeds", @environment, @table_name + ".rb")
    if File.exist?(path)
        puts "#{table_name}..."
        require path
    end
end

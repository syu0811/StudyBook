module DirectoryTreeHelper
  def directory_tree(directory_tree)
    content_tag(:ul) do
      concat(
        content_tag(:li) do
          concat(content_tag(:div, class: "list") do
            concat(image_pack_tag('folder_icon.png', onClick: "toggleDirectory(event)"))
            concat(content_tag(:div, 'ノート', onClick: "setDirectoryPathParamsAjax('')", class: "content", id: "directory_notes"))
          end)
          concat(create_tree(directory_tree))
        end,
      )
    end
  end

  private

  def create_tree(trees)
    trees.each do |_path, tree|
      concat(
        content_tag(:ul, class: "child") do
          concat(
            content_tag(:li) do
              if tree[:children]
                concat(content_tag(:div, class: "list") do
                  concat(image_pack_tag('folder_icon.png', onClick: "toggleDirectory(event)"))
                  concat(content_tag(:div, tree[:name], onClick: "setDirectoryPathParamsAjax('#{tree[:path]}')", class: "content", id: "directory_#{tree[:path]}"))
                end)
              else
                concat(content_tag(:div, class: "list leaf") do
                  concat(content_tag(:div, tree[:name], onClick: "setDirectoryPathParamsAjax('#{tree[:path]}')", class: "content", id: "directory_#{tree[:path]}"))
                end)
              end
              concat(content_tag(:div, create_tree(tree[:children]))) if tree[:children]
            end,
          )
        end,
      )
    end
    nil
  end
end

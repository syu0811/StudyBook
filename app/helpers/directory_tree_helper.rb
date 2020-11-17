module DirectoryTreeHelper
  def directory_tree(directory_tree)
    content_tag :div, createTree(directory_tree)
  end

  private

  def createTree(trees)
    trees.each do |path, tree|
      concat(
        content_tag(:ul) do
          concat(
            content_tag(:li) do
              concat(link_to tree[:name], user_notes_path(params.permit(:category).merge(file_path: tree[:path])))
              if tree[:children]
                concat(content_tag :div, createTree(tree[:children]))
              end
            end
          )
        end
      )
    end
    return
  end
end

class ClientDownloadsController < ApplicationController
  OS_EXT = { 'windows' => 'exe', 'mac' => 'dmg', 'linux' => '' }.freeze

  def download
    return if OS_EXT[params[:os]].blank?

    send_file "public/client_app/study_book_client.#{OS_EXT[params[:os]]}"
  end
end

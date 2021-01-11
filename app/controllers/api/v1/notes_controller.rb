module Api
  module V1
    class NotesController < ApiBaseController
      protect_from_forgery

      def uploads
        @responses = []
        logs = []
        put_note_params[:notes].each do |note_params|
          response, log = Note.upload(@user.id, note_params[:guid], permit_note_params(note_params), note_params[:tags])
          logs.push(log) if response[:guid]
          @responses.push(response.merge(local_id: note_params[:local_id]))
        end
        StudyLog.new(@user.id).write_study_log(logs)
      end

      def downloads
        @notes = @user.notes.includes(:category, :tags).where('notes.updated_at >= ?', params[:updated_at])
        @deleted_notes = @user.deleted_notes
      end

      def destroys
        @notes = @user.notes.where(guid: (destroy_note_params[:notes].map { |note| note[:guid] })).destroy_all
      end

      private

      def put_note_params
        params.permit(notes: [:local_id, :guid, :title, :body, :category_id, :directory_path, { tags: [:id, :name] }])
      end

      def permit_note_params(note_params)
        note_params.permit(:title, :body, :category_id, :directory_path)
      end

      def destroy_note_params
        params.permit(notes: [:guid])
      end
    end
  end
end

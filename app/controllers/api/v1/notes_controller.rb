module Api
  module V1
    class NotesController < ApiBaseController
      protect_from_forgery

      def uploads
        @responses = []
        put_note_params[:notes].each do |note_params|
          respose = Note.upload(@user.id, note_params[:guid], permit_note_params(note_params), note_params[:tags])
          @responses.push(respose.merge(local_id: note_params[:local_id]))
        end
      end

      def destroys
        @notes = @user.notes.where(guid: (destroy_note_params[:notes].map { |note| note[:guid] })).destroy_all
      end

      private

      def put_note_params
        params.permit(notes: [:local_id, :guid, :title, :text, :category_id, { tags: [:id, :name] }])
      end

      def permit_note_params(note_params)
        note_params.permit(:title, :text, :category_id, :file_path)
      end

      def destroy_note_params
        params.permit(notes: [:guid])
      end
    end
  end
end
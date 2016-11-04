module Sox

	class Audio

		attr_reader :content_type, :normalized_filename, :normalized_file_path

		def initialize(file)
			filename = file.original_filename
			tempfile = file.tempfile
			@content_type = file.content_type
			@tempfile_path = tempfile.path
			@normalized_filename = append_normalized_to_filename(filename)
			@normalized_file_path = tmp_file_path(@normalized_filename)
		end

		def normalize
			system "sox --norm #{@tempfile_path} #{@normalized_file_path.shellescape}"
		end

		def delete_tempfiles
			Dir.foreach(tmp_file_path()) do |file| 
				if ["mp3", "wav"].include? file[-3..-1]
					File.delete(tmp_file_path(file))
				end
			end
		end

		private

		def append_normalized_to_filename(filename)
			array = filename.split('.')
			extension = array.pop
			"#{array.join('.')}_NRMLZD.#{extension}"
		end

		def tmp_file_path(filename = "")
		  Rails.root.join('tmp', filename).to_s
		end

	end

end
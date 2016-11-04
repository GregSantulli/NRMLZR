(function() {

	function fileChangeListener(idString){
		var inputId = "#" + idString
		var fileInput = $(inputId) 
		fileInput.bind('change', function(){ 
			toggleButtonDisabled(this.value)
			updateView(this)
		})
	}

	function toggleButtonDisabled(input){
		var button = $('.submit')
		if(input){
		  button.removeAttr('disabled')
		} else {
			button.attr('disabled', 'disabled')
		}
	}

	function updateView(input){
		var file = input.files[0]
		var fileName = "" 
		  , fileSize = "";
		if (file) {
			$('.error-messages').html("")
			fileName = file.name
			fileSize = formatFileSize(file.size)
		}
		$('.filename').html(fileName)
		$('.filesize').html(fileSize)
	}

	function formatFileSize(bytes){
		units = ["bytes", "KB", "MB", "GB", "TB",]
		unit = 0
		while(bytes / 1024 > 1){
			bytes = bytes /1024
			unit += 1
		}
		return Math.round(bytes) + " " + units[unit]
	}

	$(document).ready(function(){
		$('.submit').attr('disabled', 'disabled')
		fileChangeListener('audio_file')
	})

})();




$(document).ready(function(){
	console.log("hi")

	$('.submit').attr('disabled', 'disabled')



	$('#audio_file').bind('change', function(){ 
		if($('#audio_file').value != "") {
		  $('.submit').removeAttr('disabled')
		} else {
			$('.submit').attr('disabled', 'disabled')
		}
		$('.filename').html(this.files[0].name)
		$('.filesize').html(Math.round(this.files[0].size / 1000) + "KB")
	})
})
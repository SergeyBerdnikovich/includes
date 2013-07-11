var include_id = "";

$(document).ready(function(){
	$("[id^='include_include_type_id']").click(function(){
		selected_inlcude = $(this).attr("value")
		$.ajax({
			url: "/includes/get_options?option_type_id=" + selected_inlcude + "&include_id="+include_id,
			dataType: "text",
			cache: true
		}).done(function(data) {
			$("#include_types_options").html(data)
		});
	})
	$("[id^='include_include_type_id']:checked").click()



})
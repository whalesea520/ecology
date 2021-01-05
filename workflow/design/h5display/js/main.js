var timeoutObj = null;

var canvas = null;

var loadData = function(props) {
	$.ajax({
		url: props.url,
		type: 'POST',
		dataType: 'json',
		cache: false,
		data: props.data,
		success: function(data) {
			initialData(data);
		},
		error: function(xhr, status, err) {
			console.log(props.url, status, err.toString());
		}

	});
}

var initialData = function(data) {
	var dataParse = new DataParse();
	var workflowBase = dataParse.parse(data);
	//console.log(workflowBase);
	//console.log(getCanvasHtml(workflowBase))
	$('#mainContent').html(getCanvasHtml(workflowBase));
	canvas = document.getElementById('mainArea');

	draw(canvas.getContext('2d'), workflowBase);
	canvasHandle(canvas, workflowBase);
	hideLoadding();
	setTimeout(windowClose, 500);
}

loadData({
	url: '/workflow/design/workflowPicDisplayData.jsp',
	data: {
		requestid: document.getElementById('requestid').value,
		wfid: document.getElementById('wfid').value
	}
});

function windowClose() {
	if (isFromAutoDirect) {
		alert(alertMsg);
		window.close();
	}
}
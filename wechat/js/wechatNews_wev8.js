function openNewsPreview(url,title){
	  var width = 720;
	var height = (screen.availHeight/5)*4 ;
	  
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 720;
	diag_vote.Height = height;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}
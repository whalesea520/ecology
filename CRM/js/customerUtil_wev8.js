function getDialog(title,width,height){
    var diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:680;	
	diag.Height =height?height:420;
	diag.ShowButtonRow=false;
	diag.Title = title;
	diag.Left=($(window.top).width()-235-width)/2+235;
	return diag;
}

function showAlert(msg){
	window.top.Dialog.alert(msg);
}

//生成分页
function initPageInfo(totalPage,pageNo,pageUrl){
	kkpager.generPageHtml({
		pagerid:'discusspage',
		pno : pageNo,
		total : totalPage, //总页码
		lang : {
			prePageText : '<',
			nextPageText : '>',
			gopageBeforeText : '转到',
			gopageButtonOkText : '确定',
			gopageAfterText : '页',
			buttonTipBeforeText : '第',
			buttonTipAfterText : '页'
		},
		isShowTotalPage:false,
		isShowTotalRecords:false,
		isShowFirstPageBtn:false,
		isShowLastPageBtn:false,
		isGoPage:false,
		mode : 'click',//默认值是link，可选link或者click
		click : function(n){
			//alert(n);
			this.selectPage(n);
			//toPage(n);
			window.location.href=pageUrl+"&pageindex="+n;
		    return false;
		}
	});
}

function createIframeLinster(iframeName){

	var contentframe = document.getElementById(iframeName);
	contentframe.onload = contentframe.onreadystatechange = function() {
	     if (this.readyState && this.readyState != 'complete') 
	     	return;
	     else 
	         displayLoading(0);
	}
}


function displayLoading(state,flag){
  if(state==1){
  		var loadingHeight=jQuery("#loadingMsg").height();
	    var loadingWidth=jQuery("#loadingMsg").width();
	    jQuery("#loadingMsg").css({"top":document.body.clientHeight/2 - loadingHeight/2,"left":document.body.scrollLeft + document.body.clientWidth/2 - loadingWidth/2});
	    jQuery("#loading").show();
    }else{
        jQuery("#loading").hide();
    }
}


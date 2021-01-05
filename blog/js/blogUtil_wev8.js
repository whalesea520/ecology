
 /*chartType 报表类型  blog 微博 mood心情 
  value需要查看的人员或者部门、分部id 
  year 年份 
  type 1人员 2 分部 3 部门 
  title报表标题
*/
function openChart(chartType,value,year,type,title){

    var diag = new window.top.Dialog();
    diag.Modal = true;
    diag.Drag=true;
	diag.Width = 680;
	diag.Height = 420;
	diag.ShowButtonRow=false;
	diag.Title = title;

	diag.URL = "/blog/blogChart.jsp?chartType="+chartType+"&value="+value+"&type="+type+"&year="+year+"&title="+title;
    diag.show();
 }
 
 
 function viewRecord(obj,flag){

		jQuery(".tdActive").removeClass("tdActive");
		jQuery(obj).find("div").addClass("tdActive");
		var viewRecord=jQuery("#viewRecord")[0];
		if(flag==0){
		   jQuery("#stateOk").hide();
		   jQuery("#stateNo").show();
		   jQuery("#stateNoDiv").show();
		   jQuery("#stateOkDiv").hide();
		}else{
		   jQuery("#stateOk").show();
		   jQuery("#stateNo").hide();
		   jQuery("#stateNoDiv").hide();
		   jQuery("#stateOkDiv").show();
		}
        jQuery("#viewRecord").show();
		var coloPanelWidth=viewRecord.offsetWidth;
		var coloPanelHeight=viewRecord.offsetHeight;
 
		var rightedge=document.body.clientWidth-event.clientX
		var bottomedge=document.body.clientHeight-event.clientY
		
		if (rightedge<coloPanelWidth)
			viewRecord.style.left=getPosLeft(obj)-viewRecord.offsetWidth;
		else
			viewRecord.style.left=getPosLeft(obj)+jQuery(obj).width()+5+3;
			
		
		if (bottomedge<coloPanelHeight)
			viewRecord.style.top=document.body.scrollTop+event.clientY-viewRecord.offsetHeight
		else
			viewRecord.style.top=getPosTop(obj);
	}
	
	function getPosLeft(obj)
{
    var l = obj.offsetLeft;
    while(obj = obj.offsetParent)
    {
        l += obj.offsetLeft;
    }
    return l;
}

   function getPosTop(obj)
{
    var l = obj.offsetTop;
    while(obj = obj.offsetParent)
    {
        l += obj.offsetTop;
    }
    return l;
}
 
 

function closeDiv(){
   jQuery("#viewRecord").hide();
   jQuery(".tdActive").removeClass("tdActive");
}

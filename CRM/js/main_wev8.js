//读取更多联系人
function getMoreContacterList(obj){
	var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
	var _pagesize = $(obj).attr("_pagesize");
	var _total = $(obj).attr("_total");
	var _customerid = $(obj).attr("_customerid");
	var _sellchanceid = $(obj).attr("_sellchanceid");
	//var _querysql = $(obj).attr("_querysql");
	$(obj).html("<img src='../images/loading3_wev8.gif' align='absMiddle'/>");
	$.ajax({
		type: "post",
	    url: "/CRM/manage/contacter/Operation.jsp",
	    data:{"operation":"get_list_contacter","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"customerid":_customerid,"sellchanceid":_sellchanceid}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
	    	var txt = $.trim(data.responseText);
		    var parenttr = $(obj).parent().parent("tr");
		    parenttr.before(txt);
		    if(_sellchanceid!=""){
		    	$("tr.contacter_"+_sellchanceid+"_"+_customerid).show();
		    }else{
		    	$("tr.contacter"+_customerid).show();
		    }
	    	if(_currentpage*_pagesize>=_total){
	    		parenttr.remove();
		    }else{
		    	$(obj).attr("_currentpage",_currentpage).html("更多").show();
			}
		}
    });
}			
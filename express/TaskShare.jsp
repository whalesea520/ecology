
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.docs.docs.DocImageManager"%>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
   <script language="javascript" src="/express/js/jquery-1.8.3.min_wev8.js"></script>
   <script language="javascript" src="/express/js/jquery.fuzzyquery.min_wev8.js"></script>
   <link rel="stylesheet" href="/express/css/base_wev8.css" />
   <script src="/express/js/util_wev8.js"></script>
</head>
<body>

<style type="text/css">
     html,body{-webkit-text-size-adjust:none;margin: 0px;overflow: hidden;}
	 *{font-size: 12px;font-family: Arial,'微软雅黑';outline:none;}
	.datatable{width: 100%;}	
	.datatable td{padding-left: 5px;padding-top:1px;padding-bottom:1px;text-align: left;}
	.datatable td.title{font-family: 微软雅黑;color: #999999;vertical-align: top;padding-top: 7px;padding-bottom: 7px;padding-left: 20px;background: #F6F6F6;border-top: 1px #F6F6F6 solid;border-bottom: 1px #F6F6F6 solid;}
	.datatable td.data{vertical-align: middle;border-top: 1px #fff solid;border-bottom: 1px #fff solid;}
	.feedrelate{display: none;}
	.feedrelate td{background: #fff !important;border-top: 1px #fff solid !important;border-bottom: 1px #fff solid !important;}
	
	.div_show{word-wrap:break-word;word-break:break-all;width: 90%;line-height: 20px;min-height:20px;}
	.div_show p{padding: 0px;margin: 0px;line-height: 20px !important;}
	.input_def{word-wrap:break-word;word-break:break-all;width: 90%;height:23px;line-height: 23px;border: 1px #fff solid;padding-left: 4px;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;behavior:url(/express/css/PIE2.htc);}
	.input_over{border: 1px #F0F0F0 solid;background: #fff;}
	.input_focus{border: 1px #1A8CFF solid;background: #fff;box-shadow:0px 0px 2px #1A8CFF;-moz-box-shadow:0px 0px 2px #1A8CFF;-webkit-box-shadow:0px 0px 2px #1A8CFF;}
	.content_def{width: 90%;min-height:20px;line-height: 20px;border: 1px #fff solid;padding: 3px;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;text-align: left;behavior:url(/express/css/PIE2.htc);}
	.content_def p{padding: 0px;margin: 0px;}
	.content_over{border: 1px #F0F0F0 solid;background: #fff;}
	.content_focus{border: 1px #1A8CFF solid;background: #fff;box-shadow:0px 0px 3px #1A8CFF;-moz-box-shadow:0px 0px 3px #1A8CFF;-webkit-box-shadow:0px 0px 3px #1A8CFF;}
	.feedback_def{width: 90%;min-height:30px;margin-bottom:30px;line-height: 20px !important;border: 1px #D7D7D7 solid;padding: 0px;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;text-align: left;behavior:url(/express/css/PIE2.htc);}
	.feedback_def p{padding: 0px;margin: 0px;line-height: 20px !important;}
	.feedback_over{border: 1px #C8C8C8 solid;}
	.feedback_focus{min-height:50px;margin-bottom: 5px;border: 1px #1A8CFF solid;box-shadow:0px 0px 3px #1A8CFF;-moz-box-shadow:0px 0px 3px #1A8CFF;-webkit-box-shadow:0px 0px 3px #1A8CFF;}
	a.slink{padding-right: 5px;border-right: 0px #DBDBDB dashed;}
	a.slink,a.slink:active,a.slink:visited{color: #DBDBDB !important;text-decoration: none;}
	a.slink:hover{color: #1A8CFF !important;text-decoration: underline;}
	a.sdlink{color: #000 !important;text-decoration: none !important;cursor: default;font-weight: bold;}
	a.sdlink:hover,a.sdlink:active,a.sdlink:visited{color: #000 !important;text-decoration: none !important;}
	
	#rightinfo a,#rightinfo a:active,#rightinfo a:visited{text-decoration: none;color: #000000;}
	#rightinfo a:hover{text-decoration: underline;color: #0080FF;}
	
	tr.tr_over td{background: #F4F4F4 !important;border-top:1px #E6E9EC solid !important;border-bottom:1px #E6E9EC solid !important;}
	.upload{display: ;float: left;}
	tr.tr_over .upload{display: ;}
	.btn_add{width:40px;height:22px;float: left;margin-left: 10px;margin-top: 1px;margin-bottom: 1px;
		background: url('/express/task/images/edit_wev8.png') center no-repeat;display: none;cursor: pointer;}
	.btn_browser{width:40px;height:22px;float: left;margin-left: 5px;margin-top: 1px;margin-bottom: 1px;display: none;cursor: pointer;
		background: url('/express/task/images/browser_wev8.png') center no-repeat !important;}
	.browser_hrm{background: url('/express/task/images/browser_wev8.png') center no-repeat;}
	.browser_doc{background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;}
	.browser_wf{background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;}
	.browser_meeting{background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;}
	.browser_crm{background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;}
	.browser_proj{background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;}
	.add_input{width: 100px;height:20px;line-height: 20px;border: 1px #fff solid;padding-left: 2px;display: none;margin-left：5px;
		border: 1px #1A8CFF solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
		box-shadow:0px 0px 2px #1A8CFF;-moz-box-shadow:0px 0px 2px #1A8CFF;-webkit-box-shadow:0px 0px 2px #1A8CFF;float: left;
		behavior:url(/express/css/PIE2.htc);}
		
	.txtlink{line-height:24px;float: left;margin-left: 3px;}
	
	.btn_del{width: 16px;height: 16px;background: url('/express/task/images/mainline_wev8.png') no-repeat -80px -126px;display: none;cursor: pointer;float: left;margin-left: 0px;}
	.btn_wh{width: 16px;height: 16px;float: left;margin-left: 0px;}
	
	.dtitle{width: 100%;height: 31px;line-height: 26px;font-weight: bold;border-bottom: 0px #E8E8E8 solid;cursor: pointer;
		background: url('/express/images/title_bg_01_wev8.png') repeat-x;}
	.dtxt{height: 26px;float: left;margin-left: 10px;font-family: 微软雅黑;}
	
</STYLE>
		<table class="datatable" cellpadding="0" cellspacing="0" border="0" align="center">
			<COLGROUP><COL width="20%"><COL width="80%"></COLGROUP>
				<TBODY>		
				<tr>
					<td class="title">分享给</TD>
					<td class="data">
				  		<input id="sharerid" name="sharerid" class="add_input" _init="1" _searchwidth="80" _searchtype="hrm"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_hrm" onClick="onShowHrms('sharerid')"></div>
				  		<input type="hidden" id="sharerid_val" value=""/>
				  	</td>
				</tr>
			</TBODY>
  		</table>
<script language="javascript">
	var tempval = "";
	var tempbdate = "";
	var tempedate = "";
	var oldname = "";
	var foucsobj2 = null;
	var detailid = "";
	$(document).ready(function(){

		//表格行背景效果及操作按钮控制绑定
		$("table.datatable").find("tr").bind("click mouseenter",function(){
			$(".btn_add").hide();$(".btn_browser").hide();
			$(this).addClass("tr_over");
			$(this).find(".input_def").addClass("input_over");
			$(this).find("div.content_def").addClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").show();
				$(this).find("div.btn_browser").show();
			}
		}).bind("mouseleave",function(){
			$(this).removeClass("tr_over");
			$(this).find(".input_def").removeClass("input_over");
			$(this).find("div.content_def").removeClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").hide();
				$(this).find("div.btn_browser").hide();
			}
		});

		//输入添加按钮事件绑定
		$("div.btn_add").bind("click",function(){
			$(this).hide();
			$(this).nextAll("div.btn_browser").hide();
			$(this).prevAll("div.showcon").hide();
			$(this).prevAll("input.add_input").show().focus();
			$(this).prevAll("div.btn_select").show()
		});

		//单行文本输入框事件绑定
		$(".input_def").bind("mouseover",function(){
			$(this).addClass("input_over");
		}).bind("mouseout",function(){
			$(this).removeClass("input_over");
		}).bind("focus",function(){
			$(this).addClass("input_focus");
			tempval = $(this).val();
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
			if($(this).attr("id")=="name"){
				oldname = $(this).val();
				//document.onkeyup=keyListener4;
			}
		}).bind("blur",function(){
			$(this).removeClass("input_focus");
			doUpdate(this,1);
			//document.onkeydown=null;
			//document.onkeyup=null;
		});

		//联想输入框事件绑定
		$("input.add_input").bind("focus",function(){
			if($(this).attr("_init")==1){
				$(this).FuzzyQuery({
					url:"/express/task/data/GetData.jsp",
					record_num:5,
					filed_name:"name",
					searchtype:$(this).attr("_searchtype"),
					divwidth: $(this).attr("_searchwidth"),
					updatename:$(this).attr("id"),
					updatetype:"str",
					intervalTop:4,
					result:function(data,updatename,updatetype){
					  selectUpdate(updatename,data["id"],data["name"],updatetype);
					}
				});
				$(this).attr("_init",0);
			}
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
		}).bind("blur",function(e){
			//if($(this).attr("id")=="tag" && $(this).val()!=""){
			//	selectUpdate("tag",$(this).val(),$(this).val(),"str");
			//}
			$(this).val("");
			$(this).hide();
			$(this).nextAll("div.btn_add").show();
			$(this).nextAll("div.btn_browser").show();
			$(this).prevAll("div.showcon").show();
			//document.onkeydown=null;
		});
	
	});

	//显示删除按钮
	function showdel(obj){
		$(obj).find("div.btn_del").show();
		$(obj).find("div.btn_wh").hide();
	}
	//隐藏删除按钮
	function hidedel(obj){
		$(obj).find("div.btn_del").hide();
		$(obj).find("div.btn_wh").show();
	}

	//回车事件方法
	function keyListener2(e){
	    e = e ? e : event;   
	    if(e.keyCode == 13){    
	    	$(foucsobj2).blur();   
	    }    
	}
	
	//删除选择性内容
	function delItem(fieldname,fieldvalue){
		$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
		if(fieldname=="docids"||fieldname=="wfids"||fieldname=="meetingids"||fieldname=="crmids"||fieldname=="projectids"||fieldname=="taskids"||fieldname=="tag"||startWith(fieldname,"_")){
			var vals = $("#"+fieldname+"_val").val();
			var _index = vals.indexOf(","+fieldvalue+",")
			if(_index>-1 && $.trim(fieldvalue)!=""){
				vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
				$("#"+fieldname+"_val").val(vals);
			}
		}else{
			exeUpdate(fieldname,fieldvalue,'del');
		}
	}
	//选择内容后执行更新
	function selectUpdate(fieldname,id,name,type){
		var addtxt = "";
		var addids = "";
		var addvalue = "";
		
		var ids = id.split(",");
		var names = name.split(",");
		var vals = $("#"+fieldname+"_val").val();
		for(var i=0;i<ids.length;i++){
			if(vals.indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
				addids += ids[i] + ",";
				addvalue += ids[i] + ",";
				addtxt += transName(fieldname,ids[i],names[i]);
			}
		}
		$("#"+fieldname+"_val").val(vals+addids);
		if(fieldname != "partnerid" && fieldname != "sharerid") addids = vals+addids;
		
		$("#"+fieldname).before(addtxt);
	}
	
	function onShowHrms(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'add');
	    }
	}
	
	function transName(fieldname,id,name){
		var delname = fieldname;
		if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
		var restr = "";
		if(fieldname=="principalid"){
			restr += "<div class='txtlink showcon txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
		}else{
			restr += "<div class='txtlink txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
		}
		restr += "<div style='float: left;'>";
			
		if(fieldname=="principalid" || fieldname=="partnerid" || fieldname=="sharerid"){
			restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
		}else if(fieldname=="docids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+id+"') >"+name+"</a>";
		}else if(fieldname=="wfids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid="+id+"') >"+name+"</a>";
		}else if(fieldname=="crmids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
		}else if(fieldname=="projectids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/proj/process/ViewTask.jsp?taskrecordid="+id+"') >"+name+"</a>";
		}else if(fieldname=="taskids"){
			restr += "<a href=javaScript:refreshDetail("+id+") >"+name+"</a>";
		}else if(fieldname=="tag"){
			restr += name;
		}
		
		restr +="</div>"
			+ "<div class='btn_del' onclick=\"delItem('"+delname+"','"+id+"')\"></div>"
			+ "<div class='btn_wh'></div>"
			+ "</div>";
		return restr;
	}
	
	
	//替换ajax传递特殊符号
	function filter(str){
		str = str.replace(/\+/g,"%2B");
	    str = str.replace(/\&/g,"%26");
		return str;	
	}
</script>

</body>
</html>
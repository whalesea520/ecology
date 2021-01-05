<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
	<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
	<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
	</script>
</HEAD>

<%
int childfieldid = Util.getIntValue(request.getParameter("childfieldid"), 0);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

String userid = ""+user.getUID() ;
String usertype = "0";

if(user.getLogintype().equals("2")){
	usertype = "1";
}
String fieldname = "";
String description = "";
if(isbill == 0){
	if(isdetail == 0){
		RecordSet.executeSql("select fieldname, description from workflow_formdict where id="+childfieldid);
	}else{
		RecordSet.executeSql("select fieldname, description from workflow_formdictdetail where id="+childfieldid);
	}
}else{
	RecordSet.executeSql("select fieldname, fieldlabel from workflow_billfield where id="+childfieldid);
}
if(RecordSet.next()){
	fieldname = Util.null2String(RecordSet.getString("fieldname"));
	if(isbill == 0){
		description = Util.null2String(RecordSet.getString("description"));
	}else{
		int fieldlabel = Util.getIntValue(RecordSet.getString("fieldlabel"), 0);
		description = SystemEnv.getHtmlLabelName(fieldlabel, user.getLanguage());
	}
}

String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids = "";
String selectnames = "";

if(!check_per.equals("")){
	String strtmp = "select id, selectname, selectvalue from workflow_SelectItem where fieldid="+childfieldid+" and selectvalue in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		String id_tmp = Util.null2String(RecordSet.getString("selectvalue"));
		String selectname_tmp = Util.null2String(RecordSet.getString("selectname"));
		ht.put(id_tmp, selectname_tmp);
	}
	try{
		StringTokenizer st = new StringTokenizer(check_per, ",");
		while(st.hasMoreTokens()){
			String s = st.nextToken();
			if(ht.containsKey(s)){//如果check_per中的已选的任务此时不存在会出错
				resourceids += ","+s;
				selectnames += ","+Util.null2String((String)ht.get(s)).replace(",","~~weavercomma~~");
			}
		}
	}catch(Exception e){
		resourceids = "";
		selectnames = "";
	}
}


if(!sqlwhere.equals("")){
	sqlwhere += (" and fieldid="+childfieldid);
}else{
	sqlwhere = " where fieldid="+childfieldid;
}
if(childfieldid == 0){
	sqlwhere += " and 1=2";
}
sqlwhere += " and isbill="+isbill;

String sqlstr = "" ;

if(RecordSet.getDBType().equals("oracle")){
	sqlstr = "select distinct id, selectname, selectvalue, listorder from workflow_SelectItem " + sqlwhere + "  and (cancel IS NULL OR cancel!=1) order by listorder, id asc";
}else{
	sqlstr = "select distinct id, selectname, selectvalue, listorder from workflow_SelectItem " + sqlwhere + " and (cancel IS NULL OR cancel!=1)  order by listorder, id asc";
}
RecordSet.executeSql(sqlstr);

%>
<BODY>
<div class="zDialog_div_content">
<FORM id="SearchForm" name="SearchForm" style="margin-bottom:0" action="SelectItemBrowser.jsp" method=post>
<input type="hidden" name="sqlwhere" value="<%=xssUtil.put(sqlwhere)%>">
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="resourceids" value="">

<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
		<wea:item><%=fieldname%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21934,user.getLanguage())%></wea:item>
		<wea:item><%=description%></wea:item>
		<wea:item>
			<table class="ViewForm">
			<tr>
				<td align="center" valign="top" width="45%">
					<select size="20" id="fromList" name="fromList" multiple="true" style="width:100%;height:100%;" class="InputStyle" onclick="blur1('srcList')" onkeypress="checkForEnter('fromList', 'srcList')" ondblclick="addOne('fromList', 'srcList')">
					</select>
					<script>
						<%
						int i=0;
						int totalline=1;
						while(RecordSet.next()){
							String selectvalue_tmp = Util.null2String(RecordSet.getString("selectvalue"));
							String selectname_tmp = Util.toScreen(RecordSet.getString("selectname"), user.getLanguage());
						%>
							document.all("fromList").options.add(new Option('<%=selectname_tmp%>','<%=selectvalue_tmp%>'));
						<%}%>
					</script>
				</td>
				<td align="center" width="10%">
					<img src="/js/dragBox/img/up_wev8.png" class="upimg" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
					<br>
					<img class="leftimg" src="/js/dragBox/img/4_wev8.png" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onClick="javascript:addOne('fromList','srcList');">
					<br>
					<img class="rightimg" src="/js/dragBox/img/5_wev8.png" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:addOne('srcList','fromList');">				
					<br>
					<img class="rightallimg" src="/js/dragBox/img/6_wev8.png" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:removeAll('fromList','srcList');">
					<br>				
					<img class="leftallimg" src="/js/dragBox/img/7_wev8.png" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:removeAll('srcList','fromList');">				
					<br>
					<img class="downimg" src="/js/dragBox/img/down_wev8.png"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
				</td>
				<td align="center" valign="top" width="45%">
					<select size="20" id="srcList" name="srcList" multiple="true" style="width:100%;height:100%;" class="InputStyle" onclick="blur1('fromList')" onkeypress="checkForEnter('srcList','fromList')" ondblclick="addOne('srcList','fromList')">
					</select>
				</td>
			</tr>
			</table>		
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="btnok_onclick();">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btncancel_onclick();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY></HTML>


<script language="javascript">
jQuery(document).ready(function(){
	initUDLR();
	loadToList();
});

function initUDLR(){
	jQuery(".upimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/up-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/up_wev8.png");
	});
	
	jQuery(".leftimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/4-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/4_wev8.png");
	});
	
	jQuery(".rightimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/5-h_wev8.png");
	},function(){
		
		jQuery(this).attr("src","/js/dragBox/img/5_wev8.png");
	});

	jQuery(".leftallimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/7-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/7_wev8.png");
	});
	
	jQuery(".rightallimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/6-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/6_wev8.png");
	});		
	
	jQuery(".downimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/down-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/down_wev8.png");
	});		
}
document.oncontextmenu=function(){
	   return false;
}

function loadToList(){
	var idsArr = "<%=resourceids%>".split(",");
	var namesArr = "<%=selectnames%>".split(",");
	jQuery.each(idsArr,function(i,id){
		if(i > 0){
			jQuery('#srcList').append('<option value="'+id+'">'+namesArr[i].replace(/~~weavercomma~~/g,',')+'</option>');
			jQuery('#fromList option[value='+id+']').remove();
		}
	});
}

function upFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
		}
	}
}


function removeAll(fromList, to){
	jQuery('#'+to).append(jQuery('#'+fromList).html());
	jQuery('#'+fromList).html('');
}

function downFromList(){
	var selectedoption = jQuery('#srcList option:selected');
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
		}
	}
}

//xiaofeng
function addOne(m1, m2){  
	if(jQuery('#'+m1+" option:selected").length > 0){
		jQuery('#'+m1+" option:selected").each(function(){
			jQuery('#'+m2).append('<option value="'+jQuery(this).val()+'">'+jQuery(this).html()+'</option>');
			jQuery(this).remove();
		});
	}else{
		var option = jQuery('#'+m1+' option:eq(0)');
		if(option.get(0)){
			jQuery('#'+m2).append('<option value="'+option.val()+'">'+option.html()+'</option>');
			option.remove();
		}
	}
}


function blur1(m){
	jQuery('#'+m +' option').each(function(){
		jQuery(this).attr('selected',false);
	});
}

function checkForEnter(m1, m2) {
   var charCode =  event.keyCode;
   if (charCode == 13) {
	  addOne(m1, m2);
   }
   return false;
}

function btnclear_onclick() {
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}


function btnok_onclick() {
	var resourceids1 = "";
	var selectnames1 = "";
	 
 	jQuery('#srcList option').each(function(){
		resourceids1 += ","+jQuery(this).val();
		selectnames1 += ","+jQuery(this).html();
	});
	 
	var returnjson  = {id:resourceids1, name: selectnames1};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}	 
}

function btnsub_onclick() {
	 $G("btnsub", window.parent.document).click()
}

function btncancel_onclick() {
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}

</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

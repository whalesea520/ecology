<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />

<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<script type="text/javascript">
			var parentWin = null;
			var dialog = null;
			try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
			}catch(e){}
		</script>
		
		<%
			String value = Util.null2String(request.getParameter("value"));		
			String isBill = value.substring(0, value.indexOf("_"));	  	
		  	String formID = value.substring(value.indexOf("_") + 1, value.lastIndexOf("_"));	
		  	String workflowID = value.substring(value.lastIndexOf("_") + 1);		  	
			if(workflowID.equals("0")){workflowID="";}
			String workFlowName = Util.null2String(request.getParameter("workFlowName"));
            String customid = Util.null2String(request.getParameter("customid"));
			String resourceids = "";		
			String resourcenames = "";
		
			if(!workflowID.equals(""))
			{
				try
				{
				    workflowID = WorkflowVersion.getActiveVersionWFID(workflowID);
					String SQL = "SELECT * FROM WorkFlow_Base WHERE ID IN ( " + workflowID + ")";
					RecordSet.executeSql(SQL);
					//System.out.println(SQL);
					Hashtable hashtable = new Hashtable();
					while(RecordSet.next())
					{
					    hashtable.put(RecordSet.getString("ID"), RecordSet.getString("workFlowName"));
					}

					StringTokenizer st = new StringTokenizer(workflowID, ",");

					while(st.hasMoreTokens())
					{
						String s = st.nextToken();
						resourceids += "," + s;
						resourcenames += "," + hashtable.get(s).toString();
					}
				}
				catch(Exception e)
				{
					
				}
			}
		%>
	</HEAD>
		
	<BODY>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;

			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;

			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;

			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
	   	<jsp:param name="mouldID" value="workflow"/>
	  	 <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(15295,user.getLanguage()) %>"/>
		</jsp:include>
		<div class="zDialog_div_content">
		<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkFlowofFormBrowser.jsp" method=post>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doSearch()"/>
					<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>

<wea:layout type="2col">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(2079, user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle name="workFlowName" maxlength=60 value="<%=workFlowName%>">
			<input type="hidden" name="value" value="<%= isBill %>_<%= formID %>_<%= workflowID %>">
		</wea:item>
		<wea:item attributes="{'colspan':'full'}"> </wea:item>
		<wea:item attributes="{'isTableList':'true'}">
	<TABLE class=Shadow>
		<colgroup>
		<col width="45%">
		<col width="10%">
		<col width="45%">
		</colgroup>
							
<TR width="100%">
	<!--================== 显示列表 ==================-->
	<TD valign="top">
		<TABLE  cellpadding="1"  class="ListStyle"  cellspacing="0" STYLE="margin-top:0;width:100%;" align="left">
			<TR class=header>
				<TH width="0%" style="display:none"><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></TH>
				<TH width="90%"><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></TH>
			 	<TH width="7%"></TH>
			</TR>
			<TR>
				<TD colspan="3" width="100%">
					<DIV style="overflow-y:scroll;width:100%;height:350px">
						<TABLE width="100%" id="BrowseTable"  >
							<%
								int i = 0;													
								String subCompanyString = "";														
								String SQL = "SELECT * FROM WorkFlow_Base WHERE formID = " + formID + " AND isBill = '" + isBill + "' AND isValid = '1'";								
								int detachable = 0;
                                if(customid!=null&&!customid.trim().equals("")){
                                    RecordSet.executeSql("select workflowids from WorkFlow_custom where id="+customid);
                                    String workflowids="";
                                    if(RecordSet.next()){
                                        workflowids=Util.null2String(RecordSet.getString("workflowids")).trim();
                                    }
                                    if(!workflowids.equals("")){
                                        SQL+=" and id in ("+workflowids+")";
                                    }
                                }else{
									boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
									if(isUseWfManageDetach){
										detachable = 1;
									}
							    	if(1 == detachable)
							    	{
										int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowManage:All");
																										
										for(int j = 0; j < subCompany.length; j++)
										{
										    subCompanyString += subCompany[j] + ",";
										}
										if(!"".equals(subCompanyString) && null != subCompanyString)
										{
										    subCompanyString = subCompanyString.substring(0, subCompanyString.length() - 1);
										}
							    	}	
									
										
									if(!"".equals(subCompanyString) && null != subCompanyString)
									{
									    SQL += " AND subCompanyID IN (" + subCompanyString + ")";
									}
                                                  }
								
								if(!"".equals(workFlowName) && null != workFlowName)
								{
								    SQL += " AND workFlowName LIKE '%" + workFlowName + "%'";
								}
							
								//out.println(SQL);
							
								RecordSet.executeSql(SQL);
								
								while(RecordSet.next())
								{																													
							%>
									<TR class=DataLight>
										<TD style="display:none"><A HREF=#><%= RecordSet.getString("ID") %></A></TD>
										<TD width="90%"><%= RecordSet.getString("workFlowName") %></TD>																																
									</TR>
							<%}%>
						</TABLE>
					</DIV>
				</TD>
			</TR>	            
		</TABLE>
	</TD>
	
	<td align="center">
					<img class="upimg" src="/js/dragBox/img/up_wev8.png" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
					<br><br>
					<img class="rightall" src="/js/dragBox/img/6_wev8.png" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onclick="javascript:addAllToList();">
					<br><br>					
					<img class="leftimg" src="/js/dragBox/img/5_wev8.png" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="javascript:deleteFromList();">
					<br><br>
					<img class="leftall" src="/js/dragBox/img/7_wev8.png" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
					<br><br>					
					<img class="downimg" src="/js/dragBox/img/down_wev8.png"   title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">	
	</td>
		<TD valign="top">
			<TABLE cellspacing="1" align="left" width="100%" height="100%">
				<TR> <td colspan="3" height="30px"></td> </TR>			
				<TR>
					<TD align="center" valign="top" width="95%" height="350px">
						<select size="15" name="srcList" multiple="true" style="width:100%;height:100%;" class="InputStyle">																								
						</select>
					</TD>
				</TR>									
			</TABLE>
		</TD>
	</TR>
</TABLE>		
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
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="btnclear_onclick()">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>		
	</BODY>
</HTML>



<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
})
function BrowseTable_onclick(e){
	var target =  e.srcElement||e.target ;
	try{
	if(target.nodeName == "TD" || target.nodeName == "A"){
		var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+$($(target).parents("tr")[0].cells[1]).text() ;
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect($("select[name=srcList]")[0],newEntry);
			reloadResourceArray();
		}
	}
	}catch (en) {
		alert(en.message);
	}
}

	resourceids = "<%=resourceids%>"
	resourcenames = "<%=resourcenames%>"

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}


function btnok_onclick(){
	setResourceStr();
  	var returnjson = {id:resourceids,name:resourcenames};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}	
}

function btnsub_onclick(){
	doSearch();
}

function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}
/**
加入一个object 到Select List
 格式object ="1~董芳"
*/
function addObjectToSelect(obj,str){
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	$(oOption).val(str.split("~")[0]);
	$(oOption).text(str.split("~")[1])  ;
	
}

function isExistEntry(entry,arrayObj){
	for(var i=0;i<arrayObj.length;i++){
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
}

function upFromList(){
	var destList  = $("select[name=srcList]")[0];
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
   reloadResourceArray();
}
function addAllToList(){
	var table =$("#BrowseTable");
	$("#BrowseTable").find("tr").each(function(){
		var str=$($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text();
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect($("select[name=srcList]")[0],str);
	});
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
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
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = $("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
}

function setResourceStr(){
	resourceids ="";
	resourcenames = "";
	var resourceidArray=new Array();
	var resourceNameArray=new Array();
	resourceidArray.toString()
	for(var i=0;i<resourceArray.length;i++){
		resourceidArray.push(resourceArray[i].split("~")[0]);
		resourceNameArray.push(resourceArray[i].split("~")[1]);
	}
	resourceids=resourceidArray.toString();
	resourcenames=resourceNameArray.toString();
}
function CheckAll(checked) {
	len = document.SearchForm.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		if (document.SearchForm.elements[i].name=='check_per') {
			if(!document.SearchForm.elements[i].checked) {
				resourceids = resourceids + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(0).innerText;
		   		resourcenames = resourcenames + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(2).innerText;
		   	}
		   	document.SearchForm.elements[i].checked=(checked==true?true:false);
		}
 	}
}
function doSearch()
{
	setResourceStr();
	var value = document.all("value").value;
    document.all("value").value = value.substring(0, value.lastIndexOf("_")) + "_" + resourceids;

    document.SearchForm.submit();
}

jQuery(document).ready(function(){
	initUDLR();
});

function initUDLR(){
	jQuery(".upimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/up-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/up_wev8.png");
	});
	
	jQuery(".leftimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/5-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/5_wev8.png");
	});
	
	jQuery(".rightall").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/6-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/6_wev8.png");
	});
	
	jQuery(".leftall").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/7-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/7_wev8.png");
	});		
	
	jQuery(".downimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/down-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/down_wev8.png");
	});		
}
</script>
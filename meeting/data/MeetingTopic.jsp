
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.meeting.util.html.HtmlUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<jsp:useBean id="MeetingFieldGroupComInfo" class="weaver.meeting.defined.MeetingFieldGroupComInfo" scope="page"/>
<%!
private String getCustomerLinkStr(weaver.crm.Maint.CustomerInfoComInfo comInfo,String crmids){
	String returnStr ="";
	ArrayList a_crmids = Util.TokenizerString(crmids,",");
	for(int i=0;i<a_crmids.size();i++){
		String id = (String)a_crmids.get(i);
		returnStr += comInfo.getCustomerInfoname(id)+",";
	}
	return returnStr ;
}
%>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

char flag=Util.getSeparator() ;
String ProcPara = "";

String meetingid = Util.null2String(request.getParameter("meetingid"));



%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/ecology8/request/seachBody_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script language=javascript src="/js/weaverTable_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2108,user.getLanguage());
String needfav ="1";
String needhelp ="";

String needcheck="";
int topicrows=0;
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button"
				value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
				class="e8_btn_top middle" onclick="doSave()">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<div class="zDialog_div_content">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
<td height="10" ></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE width=100% class="Shadow">
<tr>
<td valign="top">

<FORM id=weaver name=weaver action="/meeting/data/MeetingTopicOperation.jsp" method=post >
<input type="hidden" name="method" value="edit">
<input type="hidden" name="meetingid" value="<%=meetingid%>">
<input type="hidden" name="topicrows" value="0">
		<div id="topicRowSource" style="display:none;">
	   		<div name='topicRowSourceDiv' id="topicRowSource_0" fieldName="topicChk" fieldid="0">
	   			<input name="topicChk" type="checkbox" value="1" rowIndex='#rowIndex#'>
	   		</div>
	   		<%
	   		int topicColSize=1;
        	MeetingFieldManager hfm2 = new MeetingFieldManager(2);
        	List<String> groupList=hfm2.getLsGroup();
        	List<String> fieldList=null;
        	Hashtable<String,String> ht=null;
        	for(String groupid:groupList){
        		fieldList= hfm2.getUseField(groupid);
        		int i=0;
        		if(fieldList!=null&&fieldList.size()>0){
	        		topicColSize=fieldList.size()+1;
        			for(String fieldid:fieldList){
        				i++;
						String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
	        			String fieldVaule="";
	        			String fieldhtmltype=MeetingFieldComInfo.getFieldhtmltype(fieldid);
	        			 
	        			JSONObject cfg= hfm2.getFieldConf(fieldid);
	        			cfg.put("isdetail", 1);//明细列表显示
	        			ht=HtmlUtil.getHtmlElementHashTable(fieldVaule,cfg,user);
	        %>
	       <div name='topicRowSourceDiv' id="topicRowSource_<%=i %>" fieldName="<%=fieldname %>" fieldid="<%=fieldid %>" fieldhtmltype="<%=fieldhtmltype %>">
	       		<%=ht.get("inputStr") %>
	       </div>
	       <%if(!"".equals(ht.get("jsStr"))){ %>
	       <div id="topicRowSource_js_<%=i %>">
	       		<%=ht.get("jsStr") %>
	       </div> 
	        <%}if(!"".equals(ht.get("js2Str"))){ %>
		       <div id="topicRowSource_js_<%=i %>">
	       		<%=ht.get("js2Str") %>
	       </div> 
	        <%}
	        		}
        		}
        	}
        	%>
	   	</div>
	  <TABLE class="ViewForm">
        <TBODY>
        <TR class="Title">
            <TH>&nbsp;</TH>
            <Td class="Field"align=right>
            	<input class="addbtn" accesskey="A" onclick="addNewRow('topic');" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" type="button">
				<input class="delbtn" accesskey="E" onclick="deleteSelectedRow('topic');" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" type="button">
			</Td>
          </TR>
        <TR class="Spacing" style="height:1px!important;">
          <TD class="Line1" colspan=2></TD></TR>
         <tr>
        	<td class="Field" colspan=2>
        	<%
        	RecordSet.execute("select * from Meeting_Topic where meetingid="+meetingid);
        	for(String groupid:groupList){
        		fieldList= hfm2.getUseField(groupid);
        		
        		if(fieldList!=null&&fieldList.size()>0){
        			int colSize=fieldList.size();
        			
        	%>		<table id="topicTabField" class=ListStyle  border=0 cellspacing=1>
        			  <colgroup>
        			  	<col width="5%">
        	<%		for(int i=0;i<colSize;i++){
        				out.print("<col width='"+(95/colSize)+"%'>\n");
        			}
        			out.println("</colgroup>\n");
        			out.println("<TR class=HeaderForXtalbe>\n");
        			out.println("<th><input name=\"topicChkAll\" tarObj=\"topicChk\" type=\"checkbox\" onclick=\"jsChkAll(this)\"></th>\n");
        		  	
        			for(String fieldid:fieldList){
        				int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
        				out.println("<th>"+SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())+"</th>\n");
	        
	   				}
        			//展示历史数据
        			while(RecordSet.next()){
        				topicrows++;
        				out.print("<tr class='DataLight'>\n"); 
        				out.print("<td><input name=\"topicChk\" type=\"checkbox\" value=\"1\" rowIndex='"+topicrows+"'><input name=\"topic_data_"+topicrows+"\" type=\"hidden\" value=\""+RecordSet.getString("id")+"\" ></td>\n"); 
        				for(String fieldid:fieldList){
            				String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
            				JSONObject cfg= hfm2.getFieldConf(fieldid);
            				cfg.put("rowindex",topicrows);
            				String fieldValue = RecordSet.getString(fieldname);
            				 
            				out.println("<td>"+HtmlUtil.getHtmlElementString(fieldValue,cfg,user)+"</td>\n");
    	        
    	   				}
        				out.print("</tr>\n"); 
        			}
        			
        			
        			out.print("</tr></table>\n"); 
        		}
        	}
        	%>         
        	</td>
        </tr>
		  
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >   
</script>  
<script language=javascript>  
var rowColor="" ;
rowindex = "<%=topicrows%>";
 ////以下是议程和服务 明细列表处理
function jsChkAll(obj)
{    
   var tar=$(obj).attr("tarObj");
   $("input[name='"+tar+"']").each(function(){
		changeCheckboxStatus(this,obj.checked);
	}); 
} 
//移除 checkbox初始美化值
function removeSourceCheck(){
	$('#topicRowSource').find("input[type='checkbox']").each(function(){
		removeBeatyRadio(this);
	});
}
rowindex = "<%=topicrows%>";
function addNewRow(target){
	if(target=='topic'){
		rowindex = rowindex*1 +1;
		var oRow;
		var oCell;
		oRow = jQuery("#topicTabField")[0].insertRow(-1);
		oRow.className="DataLight";
		
		for(var i=0;i<<%=topicColSize%>;i++){
			oCell = oRow.insertCell(-1);
			var filename=jQuery("#topicRowSource_"+i).attr("fieldName");
			var fieldid=jQuery("#topicRowSource_"+i).attr("fieldid");
			var ht=jQuery("#topicRowSource_"+i).html();
			if(!!ht && ht.match(/#rowIndex#/)){
				ht=ht.replace(/#rowIndex#/g,rowindex);
			}
			oCell.innerHTML =ht;
			if(i!=0){
				if(jQuery("#topicRowSource_js_"+i)&&jQuery("#topicRowSource_js_"+i).html()!=''){
					try{
						eval("cusFun_"+fieldid+"("+rowindex+")");
					}catch(e){}
				}
			}
		}
		jQuery("#topicTabField").jNice();
		jQuery("#topicTabField").find("select").each(function(){
			jQuery(this).attr("notBeauty","");
		})
		jQuery("#topicTabField").find("select").selectbox();
	}
}
	
function deleteSelectedRow(target){
	if(target=='topic'){
		var table=$(jQuery("#topicTabField")[0]);
		var selectedTrs=table.find("tr:has([name='topicChk']:checked)");
		if(selectedTrs.size()==0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82884,user.getLanguage())%>");
			return;
		}
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>",function(){
			selectedTrs.each(function(){
				jQuery(this).remove();
			});
		});
	}
}
////以上是议程和服务 明细列表处理

function doSave(){
	if(check_form(document.weaver,'<%=needcheck%>')){
		document.weaver.topicrows.value=rowindex;
		document.weaver.submit();
	}
}

function btn_cancle(){
	 var parentWin = parent.parent.getParentWindow(window.parent);
     parentWin.diag_vote.close();
}

jQuery(document).ready(function(){
	resizeDialog(document);
	removeSourceCheck();
});

function onShowHrm(spanname,inputename,needinput){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (datas){
		if(datas.id){
			$($GetEle(spanname)).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>");
			$GetEle(inputename).value=datas.id;
		}else{ 
			if(needinput == "1"){
				$($GetEle(spanname)).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			}else{
				$($GetEle(spanname)).html("");
			}
		
			$GetEle(inputename).value=""
		}
	}
}

function onShowMProj(spanname,inputname){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if (datas){
	if(datas.id){
		$($GetEle(spanname)).html("<A href='/proj/data/ViewProject.jsp?ProjID="+datas.id+"'>"+datas.name+"</A>");
		$GetEle(inputname).value=datas.id;
	}else {
		$($GetEle(spanname)).empty();
		$GetEle(inputname).value="0"
	}}
}

function onShowMHrm(spanname,inputename){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
    if(datas){
        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
	         	alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
				return;
		 }else if(datas.id){
			resourceids = datas.id;
			resourcename =datas.name;
			sHtml = "";
			resourceids =resourceids.split(",");
			$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr("1"):resourceids;
			resourcename =resourcename.split(",");
			for(var i=0;i<resourceids.length;i++){
				if(resourceids[i]&&resourcename[i]){
					sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"  target=_blank>"+resourcename[i]+"</a>&nbsp"
				}
			}
			$("#"+spanname).html(sHtml);
        }else{
			$GetEle(inputename).value="";
			$($GetEle(spanname)).html("");
        }
    }
 }

function onShowMCrm(spanname,inputename){
			tmpids = $GetEle(inputename).value;
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+tmpids);
		    if(datas){
		        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
			         	alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
						return;
				 }else if(datas.id!=""){
					resourceids = datas.id.substr(1);
					resourcename =datas.name.substr(1);
					sHtml = "";
					$GetEle(inputename).value= resourceids;
					//$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr(1):resourceids;
					resourceids =resourceids.split(",");
					resourcename =resourcename.split(",");
					for(var i=0;i<resourceids.length;i++){
						if(resourceids[i]&&resourcename[i]){
							sHtml = sHtml+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+resourceids[i]+">"+resourcename[i]+"</a>&nbsp"
						}
					}
					$("#"+spanname).html(sHtml);
		        }else{
					$GetEle(inputename).value="";
					$($GetEle(spanname)).html("");
		        }
		    }
}
function showDetailCustomTreeBrowser(type){
	var eve=window.event;
	var eventSource = eve.srcElement||eve.target;
	var fieldid=eventSource.id.substr(0,eventSource.id.length-11);
	showCustomTreeBrowser(fieldid,type);
	
}
</script>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>

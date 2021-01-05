
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%

String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String id = Util.null2String(request.getParameter("wfid"));
String selectids=Util.null2String(request.getParameter("selectids"));
String selectvalue="";

String mouldType = Util.null2String(request.getParameter("mouldType"));
String operation = "attachViewMould";
if(mouldType.equals("")){
	mouldType="0";
}
//if(mouldType.equals("3"))operation = "attachEditMould";
String setMethod="setMouldBookMark";
if(mouldType.equals("3")){
	setMethod="setMouldBookMarkEdit";
}

if(!selectids.equals("")){
	String mnamesql="select mouldname from DocMould where id in ("+selectids+")";
	if(mouldType.equals("3")){
	  mnamesql="select mouldname from DocMouldFile where id in ("+selectids+")";
	}
     rs.executeSql(mnamesql);
	 while(rs.next()){
	  selectvalue+=rs.getString("mouldname")+",";
	 }
	 selectvalue=selectvalue.substring(0,selectvalue.length()-1);
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

var selectdatas = null;
function saveData(e,datas,name,params){
	if(selectdatas && selectdatas.id){
		selectdatas.id = selectdatas.id+","+datas.id;
		selectdatas.name = selectdatas.name+","+datas.name;
	}else{
		selectdatas = datas;
	}
}

function onSave(){
	if(check_form(weaver,'mouldids')){
       jQuery.ajax({
       	url:"officalwf_operation.jsp",
       	dataType:"json",
       	type:"post",
       	data:{
       		wfid:<%=id%>,
       		mouldType:<%=mouldType%>,
       		mouldids:jQuery("#mouldids").val(),
       		seccategory:jQuery("#secCategoryDocument",parentWin.document).val(),
       		operation:"<%=operation%>"
       	},
       	success:function(data){
       		if(data.result==1){
       			try{
       				var mouldType=<%=mouldType%>;
       				if(selectdatas){
	     				var ids = selectdatas.id.split(",");
	     				var names = selectdatas.name.split(",");
	     				for(var i=0;i<ids.length;i++){
	     					var jsonArr = [
		     					{name:"mouldId",type:"checkbox",value:ids[i]},
		     					{name:"defaultMould",type:"span",value:names[i]},
		     					{name:"operate",type:"span",value:"<a href='javascript:<%=setMethod%>(0,"+ids[i]+");'><%=SystemEnv.getHtmlLabelNames("33338",user.getLanguage())%></a>"}
	     					];
	     					if(mouldType==3){
	     						if(jQuery("#defaultEditMouldList",parentWin.document).find("input[type='checkbox'][value='"+ids[i]+"']").length==0){
		     						parentWin.editGroup.addRow(jsonArr);
		     					}
	     					}else{
		     					if(jQuery("#defaultMouldList",parentWin.document).find("input[type='checkbox'][value='"+ids[i]+"']").length==0){
		     						parentWin.group.addRow(jsonArr);
		     					}
		     				}
	     					dialog.close();
	     				}
	     			}
     			}catch(e){
     				if(window.console)console.log(e);
     			}
       		}else{
       			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83409, user.getLanguage())%>");
       		}
       	}
       });
    }
}

</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";

int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!"1".equals(isDialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(0);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM id=weaver action="offcialwf_operation.jsp" method=post onSubmit="return check_form(this,'wfid')">
	<input type="hidden" name="from" id="from" value="attachMould"/>
	<wea:layout>
		<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(mouldType.equals("3")?33420:33369,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<span>
					<%
					String completeUrl="/data.jsp?type=-99996&mouldType="+mouldType+"&isWorkflowDoc=1&selectids="+selectids; 
					String browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/mould/DocMouldMutiBrowser.jsp?mouldType="+mouldType+"&isWorkflowDoc=1&selectids=";
					String addUrl = "/docs/tabs/DocCommonTab.jsp?_fromURL=20&isdialog=1&isWorkflowDoc=1";
					if(mouldType.equals("3")){
						addUrl = "/docs/tabs/DocCommonTab.jsp?_fromURL=24&isdialog=1&isWorkflowDoc=1";
					}	
					%>
			        <brow:browser viewType="0" name="mouldids" browserValue='<%=selectids%>' 
			                browserUrl='<%=browserUrl %>'
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="2"
			                language='<%=""+user.getLanguage() %>'
			                _callback="saveData"
			                hasAdd='<%=isIE %>' addUrl='<%=addUrl %>' _callbackForAdd="saveData"
							dialogWidth="1100px"
							dialogHeight="1000px"
			                completeUrl='<%=completeUrl %>'  temptitle='<%= SystemEnv.getHtmlLabelName(mouldType.equals("3")?33420:33369,user.getLanguage())%>'
			                browserSpanValue='<%=selectvalue%>'>
			        </brow:browser>
			    </span>
			</wea:item>
		</wea:group>
	</wea:layout>

			<input type="hidden" name="isdialog" value="<%=isDialog%>">
</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</BODY></HTML>


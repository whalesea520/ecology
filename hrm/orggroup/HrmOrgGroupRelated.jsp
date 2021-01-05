
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="HrmOrgGroupComInfo" class="weaver.hrm.orggroup.HrmOrgGroupComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int orgGroupId = Util.getIntValue(request.getParameter("orgGroupId"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var parentDialog = parent.parent.getDialog(parent);
function onBtnSearchClick(){
	jQuery("#frmMain").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"/hrm/orggroup/HrmOrgGroupRelatedOperation.jsp?isdialog=1&operation=delete&orgGroupId=<%=orgGroupId%>&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}

function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null)id="";
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmOrgGroupRelatedAdd&orgGroupId=<%=orgGroupId%>";
	dialog.Width = 400;
	dialog.Height = 203;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("456,24662", user.getLanguage())%>";
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<%
    boolean canEdit=false;
    if(HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
		canEdit=true;
	}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24662,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(24002,user.getLanguage()) + "&nbsp;&nbsp;-&nbsp;&nbsp;"+HrmOrgGroupComInfo.getOrgGroupName(""+orgGroupId);
String needfav ="1";
String needhelp ="";
%>
<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%

    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:onBtnSearchClick();,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelNames("456,24662",user.getLanguage())+",javaScript:openDialog();,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javaScript:doDel();,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%

    int type = Util.getIntValue(request.getParameter("type"),-1);
    String content = Util.null2String(request.getParameter("content"));
		String qname = Util.null2String(request.getParameter("flowTitle"));
    String sqlwhere =" where orgGroupId="+orgGroupId;
    
    if (type>0) {
  	    sqlwhere = sqlwhere + " and type = "+type;
    }
    if (!content.equals("")) {
  	    sqlwhere = sqlwhere + " and content in ("+content+")";
    }

	String tabletype="";
	if(canEdit){
		tabletype="checkbox";
	}else{
		tabletype="none";
	}


int perpage=Util.getIntValue(request.getParameter("perpage"),0);

if(perpage<=1 )	perpage=10;
String backfields = "id,type,content,secLevelFrom,secLevelTo";
String fromSql  = " from HrmOrgGroupRelated ";
String orderby = " type,id " ;
//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
//operateString+=" <popedom isalwaysshow='true'></popedom> ";
operateString+=" <popedom transmethod=\"weaver.hrm.job.JobActivitiesComInfo.getJobActivityOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmJobActivities:log", user)+":"+HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)+"\"></popedom> ";
operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"0\"/>";
operateString+="</operates>";	

String tableString =" <table instanceid=\"HrmOrgGroup\" tabletype=\""+tabletype+"\" pagesize=\""+perpage+"\" >"+
                 "	   <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\" sqlprimarykey=\"id\"   sqlsortway=\"asc\" />"+
                 operateString+
                 "			<head>"+
                 "				<col width=\"40%\"   text=\""+SystemEnv.getHtmlLabelName(24663,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.hrm.orggroup.SptmForOrgGroup.getRelatedType\" />"+
                 "				<col width=\"40%\"   text=\""+SystemEnv.getHtmlLabelName(24664,user.getLanguage())+"\" column=\"content\" otherpara=\"column:type+"+user.getLanguage()+"\" transmethod=\"weaver.hrm.orggroup.SptmForOrgGroup.getRelatedName\" />"+
                 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"secLevelFrom\" orderkey=\"secLevelFrom\" otherpara=\"column:secLevelTo\" transmethod=\"weaver.hrm.orggroup.SptmForOrgGroup.getRelatedSecLevel\" />"+               
                 "			</head>"+
                 " </table>";
  %>
<!--add by dongping for fiveStar request-->

<form name="frmMain" id="frmMain"  method="post" action="">
<input class=inputstyle type="hidden" name=orgGroupId value="<%=orgGroupId%>">
<INPUT type=hidden name=content  id="content" value="<%=content%>"> 
<input type="hidden" name="operation">
<input type="hidden" name="checkedCheckboxIds">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<%if(HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){ %>
					<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelNames("456,24662",user.getLanguage())%>"></input>
				<%}if(HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){ %>
					<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
				<%} %>
							<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	 <wea:layout type="4col">
	 	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	 		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
	 		<wea:item>
				<SELECT class=InputStyle  name=type onChange="onChangeType()" >
				<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	    		<option value="2" <%if(type==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
         	<option value="3" <%if(type==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
		    </SELECT>			
			</wea:item>	
			<wea:item><span id="spanName"></span></wea:item>
			<wea:item>
				<span id="subcompany" style="display: none">
	  			<brow:browser viewType="0" name="showsubcompany" browserValue="" 
			  		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp" 
			  		hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
			  		_callback='setContent'
			      completeUrl="/data.jsp?type=164" width="210px">
			    </brow:browser>
				</span>
				<span id="department" style="display: none">
  			<brow:browser viewType="0" name="showdepartment" browserValue="" 
		  		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" 
		  		hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
		  			_callback='setContent'
		      completeUrl="/data.jsp?type=4" width="210px">
		    </brow:browser>
		    </span>
			</wea:item>
	 	</wea:group>
	 	<wea:group context="">
			<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
			</wea:group>
	 </wea:layout>
	</div>
  <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.close();">
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


<script language=javascript>

function oDelete(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")) {
        var checkedCheckboxIds = _xtable_CheckedCheckboxId();
        if (checkedCheckboxIds==""){
            alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>");
            return ;
        }
        document.frmMain.action="/hrm/orggroup/HrmOrgGroupRelatedOperation.jsp"
        document.frmMain.operation.value="Delete";        
        document.frmMain.checkedCheckboxIds.value=checkedCheckboxIds;
        document.frmMain.submit();
    }
}


function onChangeType(){
	var thisvalue = jQuery("select[name=type]").val();

	jQuery("#content").val("");
	jQuery("#subcompany").hide();
	jQuery("#department").hide();
	
	if(thisvalue==2){
		jQuery("#spanName").html("<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>");
 		jQuery("#subcompany").show();
	}else if(thisvalue==3){
		jQuery("#spanName").html("<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
 		jQuery("#department").show();
	}
}
function setContent(e,data,tr){
 jQuery("#content").val(data.id);
}

jQuery(document).ready(function(){
onChangeType();
});

var opts={
		_dwidth:'550px',
		_dheight:'550px',
		_url:'about:blank',
		_scroll:"no",
		_dialogArguments:"",
		
		value:""
	};
var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
opts.top=iTop;
opts.left=iLeft;

function onShowSubcompany(inputname,spanname){
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
    
    if (data!=null) {
		if (data.id!= "") {	
			ids = data.id.split(",");
			names =data.name.split(",");
            sHtml = "";
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
                sHtml = sHtml+"<a href="+linkurl+ids[i]+" target='_blank'>"+names[i]+"</a>&nbsp;";
				}
			}
			jQuery(spanname).html(sHtml);
			jQuery("input[name="+inputname+"]").val(data.id);
		} else {
			jQuery(spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name="+inputname+"]").val("");
	    }
}
}

function onShowDepartment(inputname,spanname){
linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
if (data!=null){
    if (data.id!=""){
    	ids = data.id.split(",");
		names =data.name.split(",");
		sHtml = "";
		for( var i=0;i<ids.length;i++){
			if(ids[i]!=""){
		    sHtml = sHtml+"<a href="+linkurl+ids[i]+" target='_blank'>"+names[i]+"</a>&nbsp;";
			}
		}
		jQuery(spanname).html(sHtml);
		jQuery("input[name="+inputname+"]").val(data.id);
	} else {
		jQuery(spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		jQuery("input[name="+inputname+"]").val("");
    }
    }
}
</script>

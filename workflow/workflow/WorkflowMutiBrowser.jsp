<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css"/>
		<style type="text/css">
		  Table.BroswerStyle TR td {
		    border-bottom:1px solid #F3F2F2!important;
		  }
		  
		  Table.BroswerStyle TR.Selected td {
		    background:#f5fafb;
		    border-bottom:1px solid #F3F2F2!important;
		  }

		  .BroswerStyle {}
		</style>
		<script type="text/javascript">
			var parentWin = null;
			var dialog = null;
			try{
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
			}
			catch(e){}

			jQuery(document).ready(function(){
				jQuery("#BrowseTable").find("tr[class!='DataHeader']").hover(function () {
			        jQuery(this).addClass("Selected");
			    }, function () {
			        jQuery(this).removeClass("Selected");
			    });
			});
			
		</script>
	</head>
<%
String check_per = Util.null2String(request.getParameter("wfids"));
if (check_per.startsWith(",")) {
	check_per = check_per.substring(1);
}
ArrayList chk_per = new ArrayList();
chk_per = Util.TokenizerString(check_per,",",false);

String documentids = "" ;
String documentnames ="";

if (!check_per.equals("")) {
	String strtmp = "select id,workflowname from workflow_base where  isvalid=1 and  id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	while(RecordSet.next()){
			documentids +="," + RecordSet.getString("id");
			documentnames += ","+RecordSet.getString("workflowname");
	}
}
String propertyOfApproveWorkFlow = Util.null2String(request.getParameter("propertyOfApproveWorkFlow"));//added by XWJ on 2005-03-16 for td:1549
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String description = Util.null2String(request.getParameter("description"));
int typeid=Util.getIntValue(request.getParameter("typeid"),0);

String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(typeid!=0){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where  isvalid=1  and workflowtype = '";
		sqlwhere += typeid;
		sqlwhere += "'";
	}
	else{
		sqlwhere += " and isvalid=1  and workflowtype = '";
		sqlwhere += typeid;
		sqlwhere += "'";
	}
}
if(!fullname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where isvalid=1  and workflowname like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and isvalid=1  and  workflowname like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where isvalid=1  and  workflowdesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and isvalid=1  and   workflowdesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}

String tmpwfright = Util.null2String(request.getParameter("tmpwfright"));
if("1".equals(tmpwfright)){

	RecordSet.executeProc("SystemSet_Select","");
	RecordSet.next();
	String detachable= Util.null2String(RecordSet.getString("detachable"));
	if(detachable.equals("1") && user.getUID()!=1){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where isvalid=1 and exists(select rsr.subcompanyid from HrmRoleMembers rm,SysRoleSubcomRight rsr where workflow_base.subcompanyid=rsr.subcompanyid and rm.roleid=rsr.roleid and rsr.rightlevel>0 and rm.resourceid="+user.getUID()+") ";

		}
		else{
			sqlwhere += " and isvalid=1 and exists(select rsr.subcompanyid from HrmRoleMembers rm,SysRoleSubcomRight rsr where workflow_base.subcompanyid=rsr.subcompanyid and rm.roleid=rsr.roleid and rsr.rightlevel>0 and rm.resourceid="+user.getUID()+") ";
		}
	}
	
}

//added by XWJ on 2005-03-16 for td:1549
if("contract".equals(propertyOfApproveWorkFlow)){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where formid = 49 and isbill = 1  and isvalid=1";
	}
	else{
	  sqlwhere += " and formid = 49 and isbill = 1 and isvalid=1";
	}
}
//out.println(sqlwhere);

%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkflowMutiBrowser.jsp" method=post>
	<!-- <div style="display:none">
		<button type=button  class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O1</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></button>
	</div> -->
	<input type="hidden" name="sqlwhere" value="<%=xssUtil.put(sqlwhere1)%>">
	<input type="hidden" name="tmpwfright" value="<%=tmpwfright%>">

	<%--added by XWJ on 2005-03-16 for td:1549--%>
	<input type="hidden" name="propertyOfApproveWorkFlow" value="<%=propertyOfApproveWorkFlow%>">
	<input type="hidden" name="wfids" value="<%=check_per%>">

	<wea:layout type="fourCol" attributes="{'expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(33806,user.getLanguage())%>
			</wea:item>
			<wea:item>
				 <select class=inputstyle title="<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage()) %>" name=typeid size=1 style="width:150px;" onChange="onSubmit()">
			    	  	<option value="0">&nbsp;</option>
				  	<%
				    	while(WorkTypeComInfo.next()){
				     	String checktmp = "";
				     	if(typeid == Util.getIntValue(WorkTypeComInfo.getWorkTypeid()))
				     		checktmp=" selected";
					%>
						<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=checktmp%>><%=WorkTypeComInfo.getWorkTypename()%></option>
					<%}%>
			  	</select>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(18499,user.getLanguage()) +  SystemEnv.getHtmlLabelName(33439,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<input class=Inputstyle name=fullname value="<%=fullname%>" style="width: 140px">
			</wea:item>
		</wea:group>
	</wea:layout>
	<table width="100%" class="BroswerStyle"  cellspacing="0" style="margin-top:0">
	    <tr width=100% class=DataHeader>
		    <th><input type="checkbox" onclick="selecteds(this);"/></th>
			<th width=5% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>
			<th width=55%><%=SystemEnv.getHtmlLabelName(18499,user.getLanguage()) +  SystemEnv.getHtmlLabelName(33439,user.getLanguage())%></th>
			<th width=40%><%=SystemEnv.getHtmlLabelName(33806,user.getLanguage())%></th>
	    </tr>
	    <tr width=100% class=Line>
	    	<th colspan="5" ></th>
	    </tr>          
	    <tr width=100%>
	     	<td width=100% colspan=5>
	       		<div style="overflow-y:scroll;width:100%;height:500px;">
					<table id="BrowseTable" class="ListStyle"  cellspacing="1" width="100%">
						<%
							if(sqlwhere.trim().equals("")){
								sqlwhere+=" where isvalid=1 ";
							}
							sqlwhere = "select id,workflowname,workflowtype from workflow_base "+sqlwhere+" order by workflowtype desc";

							RecordSet.execute(sqlwhere);
							while(RecordSet.next()){
								String ischecked = "";
								if(chk_per.contains(RecordSet.getString("id"))){
									ischecked = " checked ";
							 	}
						 %>
							<tr>
								<td>&nbsp;<input type=checkbox name="check_per" value="<%=RecordSet.getString(1)%>" <%=ischecked%>>
								</td>
								<TD style="display:none"><A HREF=#><%=RecordSet.getString(1)%></A></TD>
								<TD style="word-break: break-all;"><%=RecordSet.getString(2)%></TD>
								<TD style="word-break: break-all;"><%=WorkTypeComInfo.getWorkTypename(RecordSet.getString(3))%></TD>
							</tr>
						<%}%>
					</table>
			    </div>
   			</td>
  		</tr>
	</table>

</FORM>
</BODY>

</HTML>

<SCRIPT LANGUAGE="javascript">

var ids = "<%=documentids%>";
var names = "<%=documentnames%>";
function selecteds(obj) {
	changeCheckboxStatus('input[name="check_per"]', obj.checked);
	if(obj.checked){
		jQuery("#BrowseTable").find("tr[class!='DataHeader']").each(function() {
			if (ids.indexOf(jQuery(this).find("td:eq(1)").text()) < 0) {
				ids = ids + "," + jQuery(this).find("td:eq(1)").text();
		   		names = names + "," + jQuery(this).find("td:eq(2)").text();
			}
		});
	} else {
		jQuery("#BrowseTable").find("tr[class!='DataHeader']").each(function() {
			ids = ids.replace("," + jQuery(this).find("td:eq(1)").text(), "");
	   		names = names.replace("," + jQuery(this).find("td:eq(2)").text(), "");
		});
	}
}

function btnclear_onclick() {
     window.parent.returnValue = {id: "0",name: ""};
     window.parent.close();
}

//对返回的值进行id排序
//参考http://bbs.csdn.net/topics/390580999
function sortnumber(a,b){
	return a[0] - b[0];
}
function btnok_onclick() {
	var idssz=ids.split(',');
	var namessz=names.split(',');
	for(var i=0;i<idssz.length;i++) idssz[i]=[idssz[i],namessz[i]];
	idssz.sort(sortnumber);
	for(var i=0;i<idssz.length;i++) {
	    namessz[i]=idssz[i][1];
	    idssz[i]=idssz[i][0];
	}
	var returnjson = {id: idssz+"", name: namessz+""};//Array(documentids,documentnames)
	if(dialog){
		dialog.callback(returnjson);
	}else{
		window.parent.returnValue = returnjson;
  		window.parent.close();
	}
}


//多选
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class!='DataHeader']").bind("click",function(event){
		if($(this)[0].tagName=="TR"&&event.target.tagName!="INPUT"){
			var obj = jQuery(this).find("input[name=check_per]");
		   	if (obj.attr("checked") == true){
		   		   obj.attr("checked", false);
		   		ids = ids.replace("," + jQuery(this).find("td:eq(1)").text(), "")
		   		names = names.replace("," + jQuery(this).find("td:eq(2)").text(), "")

		   	}else{
		   		    obj.attr("checked", true);
		   		ids = ids + "," + jQuery(this).find("td:eq(1)").text();
		   		names = names + "," + jQuery(this).find("td:eq(2)").text();
		   	}

		}
		//点击checkbox框
	    if(event.target.tagName=="INPUT"){
	       var obj = jQuery(this).find("input[name=check_per]");
		   	if (obj.attr("checked") == true){
		   	    ids = ids + "," + jQuery(this).find("td:eq(1)").text();
		   		names = names + "," + jQuery(this).find("td:eq(2)").text();
		   	}else{
		   		ids = ids.replace("," + jQuery(this).find("td:eq(1)").text(), "")
		   		names = names.replace("," + jQuery(this).find("td:eq(2)").text(), "")
		   	}
	    }
		
	})
	jQuery("#BrowseTable").find("tr[class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})

});

function onSubmit() {
	jQuery("input[name='wfids']").val(ids);
	$G("SearchForm").submit()
}
function onReset() {
	$G("SearchForm").reset()
}

function submitData()
{
	btnok_onclick();
}

function submitClear()
{
	var returnjson = {id:"",name:""};
	if(dialog){
		dialog.callback(returnjson);
	}else{
		btnclear_onclick();
	}
}

function onCancel() {
	if(dialog){
		dialog.close();
	}else{
  		window.parent.close();
	}
}


</SCRIPT>

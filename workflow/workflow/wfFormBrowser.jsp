<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<HTML><HEAD>
<link REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var dialog = parent.parent.getDialog(parent);
</script>
</HEAD>
<%
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String isbill=Util.null2String(request.getParameter("isbill"));
String formname=Util.null2String(request.getParameter("formname"));
String sqlwhere = "";
if(!formname.equals("")) {
	sqlwhere = " and formname like '%"+formname+"%' ";
}
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:searchReset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="wfFormBrowser.jsp" method=post>
<input type="hidden" name="isbill" value="<%=isbill%>" >
<%
String formnametohtml = "";
if(isbill.equals("0")){    
	formnametohtml = SystemEnv.getHtmlLabelName(19516,user.getLanguage())+SystemEnv.getHtmlLabelName(19532,user.getLanguage());
}else if(isbill.equals("1")){
	formnametohtml = SystemEnv.getHtmlLabelName(468,user.getLanguage())+SystemEnv.getHtmlLabelName(19532,user.getLanguage());
} 
%>
<wea:layout type="2col">
	<wea:group context='<%=formnametohtml %>' >
		<wea:item><%=formnametohtml %></wea:item>
		<wea:item>
			<input type="text" name=formname value="<%=formname%>" class="InputStyle">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<table id=BrowseTable class="ListStyle" cellspacing="0" width="100%" >
				<tr class=header>
					<th style="display:none"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
					<%if(isbill.equals("0")){ %>      
					<th><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></th>
					<%}else if(isbill.equals("1")){ %>
					<th><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></th>
					<%}%>
				</tr>
			    <%
			    if(isbill.equals("0")) {
			    if(detachable==1){
			        //获取具有查看权限的所有机构
			        CheckSubCompanyRight mSubRight=new CheckSubCompanyRight();
			        int[] mSubCom= mSubRight.getSubComByUserRightId(user.getUID(),"WorkflowManage:All");
			        String mSubComStr="";
			        for(int i=0;i<mSubCom.length;i++){
			            if(i==0)
			                mSubComStr=String.valueOf(mSubCom[i]);
			            else
			                mSubComStr+=","+String.valueOf(mSubCom[i]);
			        }
			        String sql="";
			        if(!mSubComStr.equals("")){
			            sql = "select * from workflow_formbase where subcompanyid in("+mSubComStr +") "+sqlwhere+" order by formname";
			        }else{
			            sql = "select * from workflow_formbase where 1=2";
			        }
			        RecordSet.executeSql(sql);
			        int m = 0;
			        while(RecordSet.next()){
			            String checktmp = "";
			        %>
						<TR class=DataLight>
							<TD style="display:none"><A HREF=#><%=RecordSet.getInt("id")%></A></TD>
							<td> <%=RecordSet.getString("formname")%></TD>
						</TR>
			        <%}
			        if(!mSubComStr.equals("")){
			        	RecordSet.executeSql("select * from workflow_bill where subcompanyid in("+mSubComStr+") and invalid is null and detailkeyfield='mainid' order by id desc");
			        	while(RecordSet.next()){
			        		int tempBillId = RecordSet.getInt("id");
			        		String tablename = RecordSet.getString("tablename");
			        		if(tablename.equals("formtable_main_"+tempBillId*(-1)) || tablename.startsWith("uf_")){//新创建的表单
				        		String checktmp = "";
				            int templableid = RecordSet.getInt("namelabel");
				            String tempFormName = SystemEnv.getHtmlLabelName(templableid,user.getLanguage());
				            if (tempFormName == null) {
				            	tempFormName = "";
				            }
				            if(!formname.equals("") && tempFormName.indexOf(formname)==-1) continue;
				        %>
							<TR class=DataLight>
								<TD style="display:none"><A HREF=#><%=tempBillId%></A></TD>
								<td> <%=SystemEnv.getHtmlLabelName(templableid,user.getLanguage())%></TD>
							</TR>
			        	<%}
			        	}
			        }
			    }else{
			    	int m = 0;
			        while(FormComInfo.next()){
			            String checktmp = "";
			            if(!formname.equals("") && FormComInfo.getFormname().indexOf(formname)==-1) continue;
			        %>
						<TR class=DataLight>
							<TD style="display:none"><A HREF=#><%=FormComInfo.getFormid()%></A></TD>
							<td> <%=FormComInfo.getFormname()%></TD>
						</TR>
			        <%}
			        RecordSet.executeSql("select * from workflow_bill where invalid is null and detailkeyfield='mainid' order by id desc");
			      	while(RecordSet.next()){
			      		int tempBillId = RecordSet.getInt("id");
			      		int templableid = RecordSet.getInt("namelabel");
			      		//System.out.println("templableid:"+templableid);
			      		String tablename = RecordSet.getString("tablename");
			      		if(tablename.equals("formtable_main_"+tempBillId*(-1)) || tablename.startsWith("uf_")){
			      		String checktmp = "";
			      		if(SystemEnv.getHtmlLabelName(templableid,user.getLanguage())==null)  continue;
			      		if(!formname.equals("") && SystemEnv.getHtmlLabelName(templableid,user.getLanguage()).indexOf(formname)==-1) continue;
			        %>
						<TR class=DataLight>
							<TD style="display:none"><A HREF=#><%=tempBillId%></A></TD>
							<td> <%=SystemEnv.getHtmlLabelName(templableid,user.getLanguage())%></TD>
						</TR>
			    		<%}
			    		}
			    } } else {%>
			    <%
			    RecordSet.executeSql("select * from workflow_bill where invalid is null");
			    int m = 0;
			    while(RecordSet.next()){
			    	int tmpid = RecordSet.getInt("id");
			    	int tmplable = RecordSet.getInt("namelabel");
			     	String checktmp = "";
			     	String tablename = RecordSet.getString("tablename");
			     	if(tablename.equals("formtable_main_"+tmpid*(-1)) || tablename.startsWith("uf_")) continue;
			     	String lbname = SystemEnv.getHtmlLabelName(tmplable,user.getLanguage());
			     	if(!formname.equals("") && lbname!=null && lbname.indexOf(formname)==-1) continue;
			        %>
						<TR class=DataLight>
							<TD style="display:none"><A HREF=#><%=tmpid%></A></TD>
							<td> <%=lbname%></TD>
						</TR>
			<%
			}
			    }
			%>
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
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
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
function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
})
function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
	    var returnValueJson = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
		if(dialog){
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18683, user.getLanguage())%>",function(){
				dialog.callback(returnValueJson);
			},function(){
				onClose();
			});
		}else{  
	     window.parent.parent.returnValue = returnValueJson;
		 window.parent.parent.close();
		}     
	}
}


function submitData()
{
	if (check_form(SearchForm,''))
		SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}

function nextPage(){
	document.all("pagenum").value=parseInt(document.all("pagenum").value)+1 ;
	SearchForm.submit();	
}

function perPage(){
	document.all("pagenum").value=document.all("pagenum").value-1 ;
	SearchForm.submit();
}

function searchReset() {
	SearchForm.formname.value='';
}
</script>

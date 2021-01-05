

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />

<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
int from = Util.getIntValue(request.getParameter("from"), -1);
String callbkfun = Util.null2String(request.getParameter("callbkfun"));

String meetingtype = Util.null2String(request.getParameter("meetingtype"));
String sqlwhere="where 1=2 ";
if(!"".equals(meetingtype)){
	//召集人
	rs2.executeProc("MeetingCaller_SByMeeting",meetingtype) ;
	String whereclause="where (" ;
	int ishead=0;
	while(rs2.next()){
		String callertype=rs2.getString("callertype") ;
		int seclevel=Util.getIntValue(rs2.getString("seclevel"), 0) ;
		String rolelevel=rs2.getString("rolelevel") ;
		String thisuserid=rs2.getString("userid") ;
		String departmentid=rs2.getString("departmentid") ;
		String roleid=rs2.getString("roleid") ;
		String subcompanyid=rs2.getString("subcompanyid") ;
		int seclevelMax=Util.getIntValue(rs2.getString("seclevelMax"), 0) ;
		int jobtitleid=Util.getIntValue(rs2.getString("jobtitleid"),0) ;
		int joblevel=Util.getIntValue(rs2.getString("joblevel"),0) ;
		String joblevelvalue=rs2.getString("joblevelvalue");
		if(callertype.equals("1")){
			if(ishead==0){
				whereclause+=" t1.id="+thisuserid ;
				}
			if(ishead==1){
				whereclause+=" or t1.id="+thisuserid ;
				}
		}
		if(callertype.equals("2")){
			if(ishead==0){
				whereclause+=" t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			}
			if(ishead==1){
				whereclause+=" or t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			 }
		}
		if(callertype.equals("3")){
			if(ishead==0){
				whereclause+=" t1.id in (select resourceid from hrmrolemembers join hrmresource on  hrmrolemembers.resourceid=hrmresource.id where roleid="+roleid+" and rolelevel >="+rolelevel+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+")" ;
			}
			if(ishead==1){
				whereclause+=" or t1.id in (select resourceid from hrmrolemembers join hrmresource on  hrmrolemembers.resourceid=hrmresource.id where roleid="+roleid+" and rolelevel >="+rolelevel+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+")" ;
			}
		}
		if(callertype.equals("4")){
			if(ishead==0){
				whereclause+=" t1.id in (select id from hrmresource where seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			}
			if(ishead==1){
				whereclause+=" or t1.id in (select id from hrmresource where seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			}
		}
		if(callertype.equals("5")){
			if(ishead==0){
				whereclause+=" t1.id in (select id from hrmresource where subcompanyid1="+subcompanyid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			}
			if(ishead==1){
				whereclause+=" or t1.id in (select id from hrmresource where subcompanyid1="+subcompanyid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			}
		}
		if(callertype.equals("8")){
			if(ishead==0){
				whereclause+=" t1.id in (select id from hrmresource where jobtitle="+jobtitleid;
				if(joblevel==1){
					whereclause+=" and subcompanyid1 in ("+joblevelvalue+")";
				}else if(joblevel==2){
					whereclause+=" and departmentid in ("+joblevelvalue+")";
				}	
				whereclause+=")";
			}
			if(ishead==1){
				whereclause+=" or t1.id in (select id from hrmresource where jobtitle="+jobtitleid;
				if(joblevel==1){
					whereclause+=" and subcompanyid1 in ("+joblevelvalue+")";
				}else if(joblevel==2){
					whereclause+=" and departmentid in ("+joblevelvalue+")";
				}	
				whereclause+=")";		
			}
		}
		if(ishead==0)   ishead=1;
	}
	//召集人查询条件
	if(!whereclause.equals("where ( ") && whereclause.length() > 1){  
		whereclause+=" )" ;
		sqlwhere=whereclause;
	}
}
String sqlstr="select  t1.id,t1.lastname,t1.jobtitle,t1.departmentid from HrmResource t1 "+ sqlwhere+" and t1.status in (0,1,2,3) and t1.loginid<>' '";
int currentpage =Util.getIntValue((String)request.getParameter("currentpage"),1);
int pagesize = 20;
int totalsize =0;
int prepage=currentpage-1;
int nextpage=currentpage+1;

String selSql = "select count(*) as total from HrmResource t1 "+sqlwhere+" and t1.status in (0,1,2,3) and t1.loginid<>' '";
RecordSet.executeSql(selSql);

while(RecordSet.next()){
	totalsize=RecordSet.getInt("total");
}

int totalpage = totalsize / pagesize;
if(totalsize - totalpage * pagesize > 0) totalpage = totalpage + 1;
int pageSet=totalsize>(currentpage*pagesize)?pagesize:(pagesize-(currentpage*pagesize-totalsize));

boolean isoracle = (RecordSet.getDBType()).equals("oracle");

if(isoracle){
	selSql = "select t1.id,t1.lastname,t1.jobtitle,t1.departmentid from HrmResource t1 "+ sqlwhere+" and t1.status in (0,1,2,3) and t1.loginid<>' ' order by id asc ";
	selSql = "select t1.*,rownum rn from (" + selSql + ") t1 where rownum <= " + (currentpage*pagesize);
	selSql = "select t2.* from (" + selSql + ") t2 where rn > " + (currentpage*pagesize - pagesize);
}else{
    selSql = "select top " + currentpage*pagesize +" t1.id,t1.lastname,t1.jobtitle,t1.departmentid from HrmResource t1 "+ sqlwhere+" and t1.status in (0,1,2,3) and t1.loginid<>' ' order by id asc";
    selSql = "select top " + pageSet+" t1.* from (" + selSql + ") t1 order by id desc ";
    selSql = "select top " + pageSet+" t2.* from (" + selSql + ") t2 order by id asc ";
}
sqlstr=selSql;
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:closeDlg(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<FORM NAME=SearchForm  action="#" method=post>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<%
					//得到pageNum 与 perpage
					int perpage=12;
					//设置好搜索条件
					String backFields =" t1.id,t1.lastname,t1.jobtitle,t1.departmentid ";
					String fromSql = " HrmResource t1 ";
					sqlwhere+=" and t1.status in (0,1,2,3) and t1.loginid<>' '";
					String orderBy = "";
					String linkstr = "";
					linkstr = "";
					String tableString=""+
								"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
								"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" />"+
								"<head>"+
									"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\"  />"+
									"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" orderkey=\"jobtitle\" transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\" />";
					  tableString +="<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(18939,user.getLanguage())+"\" column=\"departmentid\"  orderkey=\"departmentid \" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" />"+
								"</head>"+
								"</table>";
				%>
				<wea:SplitPageTag isShowTopInfo="true" tableString='<%=tableString%>'  mode="run"/>
		</wea:item>
	</wea:group>
</wea:layout>

</FORM>
</BODY>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" >
		<wea:layout type="4col">
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%>"
						class="zd_btn_cancle" onclick="javascript:submitClear()">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
						class="zd_btn_cancle" onclick="javascript:closeDlg()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</HTML>
<script language="javascript">
var parentWin = parent.parent.parent.getParentWindow(parent.parent);
var dialog = parent.parent.parent.getDialog(parent.parent);

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#_xTable div.table").find("tr[class!='HeaderForXtalbe']").live("click",function(){
		 var id0  = $(this).find("td:first").next().text();
	     id0 = id0.replace("<","&lt;")
	     id0 = id0.replace(">","&gt;")
			var returnjson = {id:$(this).find("td:first").find("input").val(),name:id0};
			returnValue(returnjson);
	});

});

function submitClear()
{
	var returnjson = {id:"",name:""};
	returnValue(returnjson);
}

function returnValue(returnjson){
	if(1 == <%=from%>){
	    <%if(!"".equals(callbkfun)){%>
			<%="parentWin."+callbkfun+"(returnjson);"%>
		<%}%>
		
	} else {
		if(dialog){
			
			try{
				  dialog.callback(returnjson);
			 }catch(e){}

			try{
				 dialog.close(returnjson);
			 }catch(e){}

		}else{ 
			window.parent.parent.returnValue  = returnjson;
			window.parent.parent.close();
		}
	}
}


function closeDlg(){
	if(1 == <%=from%>){
		parentWin.closeBrwDlg();
	} else {
		if(dialog){
			dialog.close();
		}else{ 
			window.parent.parent.close();
		}
	}
	
}
</script>

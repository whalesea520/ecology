<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.form.FormManager"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
String tabid = Util.null2String(request.getParameter("tabid"));
String typeid = Util.null2String(request.getParameter("typeid"));
String workflowname = Util.null2String(request.getParameter("workflowname"));
String isbill = Util.null2String(request.getParameter("isbill"));
String isWorkflowDoc=Util.null2String(request.getParameter("isWorkflowDoc"));
int isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")));
String iswfec = Util.null2String(request.getParameter("iswfec"));
if(tabid.equals("")) tabid="1";

int uid=user.getUID();

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!workflowname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where workflowname like '%" + Util.fromScreen2(workflowname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and workflowname like '%" + Util.fromScreen2(workflowname,user.getLanguage()) +"%' ";
}
if(!isbill.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where isbill ='" + isbill +"' ";
	}
	else
		sqlwhere += " and isbill ='" +isbill +"' ";
}
if(!typeid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where workflowtype = "+ typeid ;
	}
	else
		sqlwhere += " and workflowtype ="+ typeid ;
}
if(isTemplate==1){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where isTemplate = '"+ isTemplate + "' ";
	}
	else
		sqlwhere += " and isTemplate = '"+ isTemplate + "' ";
}
if(isTemplate==0){
    if(ishead==0){
		ishead = 1;
		sqlwhere += " where (isTemplate <>'1' or isTemplate is null)";
	}
	else
		sqlwhere += " and (isTemplate <>'1' or isTemplate is null)";
}

if(isWorkflowDoc.equals("1")){
	String formids_bill = "-1";
	String formids_nobill = "-1";
	String sql = "select distinct billid from workflow_billfield where type = 9 and billid<0";
	rs.execute(sql);
	while(rs.next()){
		formids_bill = formids_bill +","+ rs.getString("billid");
	}
	sql = "select distinct formid from workflow_formfield where fieldid in (select id from workflow_formdict where type=9)";
	rs.execute(sql);
	while(rs.next()){
		formids_nobill = formids_nobill +","+ rs.getString("formid");
	}
	if(ishead==0){
		ishead=1;
		sqlwhere += " where ( (formid in ("+formids_bill+") and isbill='1') or(formid in ("+formids_nobill+") and isbill='0') )";
	}else{
		sqlwhere += " and ( (formid in ("+formids_bill+") and isbill='1') or(formid in ("+formids_nobill+") and isbill='0') )";
	}
	//sqlwhere += " and (isWorkflowDoc!=1 or isWorkflowDoc is null)";

	sqlwhere += "  and (isTemplate <>'1' or isTemplate is null)";
    //过滤已选择的流程
    //sqlwhere += " and id not in (select workflowid from DocChangeWorkflow) ";
	
	//过滤非活动的流程
	sqlwhere += " and id in (select id from workflow_base where id=activeVersionID or activeVersionID is null) ";
}

if(iswfec.equals("1")){
	if(ishead==0){
        ishead=1;
        sqlwhere += " where isvalid=1 and formid<0 and isbill='1' ";
    }else{
        sqlwhere += " and isvalid=1  and formid<0 and isbill='1' ";
    }
}

String subcompanyids="";
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int[] subCompanyId=null;

    if(detachable==1){  
        subCompanyId= CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"WorkflowManage:All");
        for(int i=0;i<subCompanyId.length;i++){
            subcompanyids+=subCompanyId[i]+",";
        }
        if(subcompanyids.length()>1){
            subcompanyids=subcompanyids.substring(0,subcompanyids.length()-1);
        }
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
            subcompanyids="";
        }else{
            subcompanyids="0";
        }
    }
if(!subcompanyids.equals("")){
    if(ishead==0){
        ishead = 1;
        sqlwhere += " where subCompanyId in("+ subcompanyids+")" ;
    }
    else
        sqlwhere += " and subCompanyId in("+ subcompanyids+")" ;
}

String sqlstr = "select id,workflowname,workflowtype,isbill,formid,isTemplate "+
			    "from workflow_base " + sqlwhere+" order by id";
//String sqlstr = "select id,workflowname,workflowtype,isbill,formid,isTemplate "+
//			    "from workflow_base " + sqlwhere+" and isTemplate = 1 order by id";
FormManager fManager = new FormManager();
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
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
</HEAD>
<BODY>

<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>	
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>

	<!--########Browser Table Start########-->
<TABLE width=100% class="BroswerStyle"  cellspacing="0" STYLE="margin-top:0">
   <TR width=100% class=DataHeader>
      <TH width=0% style="display:none"></TH>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(18499,user.getLanguage()) + SystemEnv.getHtmlLabelName(33439,user.getLanguage())%></TH>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(33806,user.getLanguage())%></TH>      
      <TH width=35%><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></TH>
      <TH width=15%><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></TH>
      
   </tr>
   <tr width=100% class=Line>
    <th colspan="5" ></th>
   </tr>          
   <tr width=100%>
     <td width=100% colspan=5>
       <div style="overflow-y:scroll;width:100%;height:216px;">
         <table width=100% id="workflowTable" cellspacing="0" class="ListStyle" style="table-layout: fixed;">
            <%

            int i=0;
            RecordSet.executeSql(sqlstr);
            while(RecordSet.next()){
            	String ids = RecordSet.getString("id");
            	String workflownames = Util.toScreen(RecordSet.getString("workflowname"),user.getLanguage());
            	String workflowtypes = RecordSet.getString("workflowtype");
            	String isbills = RecordSet.getString("isbill");
              String formids = RecordSet.getString("formid");
              String template=Util.null2String(RecordSet.getString("isTemplate"));
              String formname="";
              
              boolean isnewform = false;
              int newformlabelid = Util.getIntValue(BillComInfo.getBillLabel(formids));
              rs.executeSql("select namelabel from workflow_bill where tablename='"+fManager.getTablename(formids)+"' and id="+formids);
              if(rs.next()){
                  isnewform=true;
                  newformlabelid = rs.getInt("namelabel");
              }
                      
              if(isbills.equals("0")&&!isnewform){
                  formname=FormComInfo.getFormname(formids);
              }else{
                  formname=SystemEnv.getHtmlLabelName(newformlabelid,user.getLanguage());
              }
            %>

              <tr width="100%">
            	  <td width=0 style="display:none"><A HREF=#><%=ids%></A></td>
            	  <td width=25%> <%=workflownames%></td>	
            	  <td width=25%> <%=WorkTypeComInfo.getWorkTypename(workflowtypes)%></td>
            	  <td width=35%> <%=formname%></td>
                <%if(template.equals("1")){%>
                  <td width=15%><%=SystemEnv.getHtmlLabelName( 33658 ,user.getLanguage())%></td>
                <%}else{%>
                  <td width=15%><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></td>
                <%}%>
               </tr>
            <%}
            %>
            </table>
     </div>
   </td>
  </tr>
  
</TABLE>

 <script type="text/javascript">
   	jQuery(document).ready(function(){
  		jQuery("#workflowTable").find("tr[class!='DataHeader']").bind("click",function(){

        var result = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};

        var rootWindow = parent.parent.parent;
        var dialog = rootWindow.getDialog( parent.parent );

        if(dialog){
          dialog.callback(result);
        }else{  
          rootWindow.returnValue  = result;
          rootWindow.close();
        } 
  		});


      jQuery("#workflowTable").find("tr[class!='DataHeader']").hover(function () {
        jQuery(this).addClass("Selected");
      }, function () {
        jQuery(this).removeClass("Selected");
      });
  	});
 </script>

</BODY>
</HTML>

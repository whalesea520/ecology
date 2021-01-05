
<%@ page import="weaver.general.*,weaver.conn.*,weaver.workflow.workflow.ShowWorkFlow,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />

<%

String requestid = Util.null2String(request.getParameter("requestid")) ;
String workflowid = Util.null2String(request.getParameter("workflowid")) ;
String nodeid = Util.null2String(request.getParameter("nodeid")) ;
String isbill = Util.null2String(request.getParameter("isbill")) ;
String formid = Util.null2String(request.getParameter("formid")) ;
String sql = "" ;


%>

<SCRIPT language=VBS>
Sub window_onload()
   // imagehtml = document.all("IMAGETD").innerHTML 
   // window.parent.document.all("IMAGETD").innerHTML = imagehtml 
End Sub
</script>


<TABLE border=0 cellpadding=0 cellspacing=0><TR><TD ID='InnerIMAGETD'>
<img src = "/weaver/weaver.workflow.workflow.ShowWorkFlow?requestid=<%=requestid%>" border=0>
<%

int top0 = 0;   // ????????
int left0 = 0 ; // ×ó±?????
int nodexsize = 60;
int nodeysize = 40;
String currentnodeid="" + nodeid;

String bkcol = "";          // ????·??ò????
int icount = 0;             // ????????
int curnodetype = 0;        // ????×???  0: ???¨??  1: ?±?° 2:???ü

ArrayList operatednode = new ArrayList();               // ???¤×÷?÷???ù?????¨????????
ArrayList operaternode = new ArrayList();               // ?ù????·?±?????×÷????×÷??
ArrayList operaternode_ = new ArrayList();               // ?ù????·?±?????×÷????×÷?? added by xwj on 2005-05-15 for td1838
ArrayList viewernode = new ArrayList();                 // ?±?°?????ù?????é????
ArrayList canoperaternode = new ArrayList();            // ?±?°???????ù??????×÷??


/*
logtype :
1: ±???
2: ?á??
3: ????
4: ?????ò??
5: ????
6: ?¤??
9: ×?·?
*/

// ???¤×÷?÷???ù?????¨???????? logtype = 2
sql = "select distinct nodeid from workflow_requestLog where logtype='2' and requestid = "+requestid;
rs.executeSql(sql);
while(rs.next())
{
	String nodeid1 = Util.null2String(rs.getString("nodeid"));
	operatednode.add(nodeid1);
}

// ?±?°???????ù??????×÷??
sql = "select distinct userid,usertype from workflow_currentoperator where (isremark = '0'  or  isremark = '4' ) and requestid = "+ requestid ;
rs.executeSql(sql);
while(rs.next())
{
	String operator = Util.null2String(rs.getString("userid"));
	String operatortype = Util.null2String(rs.getString("usertype"));
	canoperaternode.add(operator+"_"+operatortype);
}

// ?ù????·?±?????×÷????×÷??
sql = "select distinct nodeid,operator,operatortype from workflow_requestLog where requestid = "+requestid + " and logtype != '1' " ;
rs.executeSql(sql);
while(rs.next())
{
	String nodeid1 = Util.null2String(rs.getString("nodeid"));
	String operator = Util.null2String(rs.getString("operator"));
	String operatortype = Util.null2String(rs.getString("operatortype"));
	operaternode.add(nodeid1+"_"+operator+"_"+operatortype);
	operaternode_.add(operator); //added by xwj for td1838 on 2005-05-15
}


// ----------- Modefied by xwj on 2005-05-15 for td1838   B E G I N  --------------------
// ?±?°?????????é????   
sql = "select distinct userid,usertype from workflow_currentoperator where isremark in ('2') and requestid = "+ requestid ;
rs.executeSql(sql);
ArrayList tempList = new ArrayList();
tempList = operaternode_;
String tempUserId = "";
while(rs.next()){
  tempUserId = Util.null2String(rs.getString("userid"));
  if(tempList.contains(tempUserId)){
     tempList.remove(tempUserId);
  }
}
sql = "select distinct viewer,viewtype from workflow_requestViewLog where id = "+ requestid + " and currentnodeid = "+currentnodeid;
rs.executeSql(sql);
while(rs.next())
{
	String operator = Util.null2String(rs.getString("viewer"));
	String operatortype = Util.null2String(rs.getString("viewtype"));
	if(!operaternode_.contains(operator)){
	viewernode.add(operator+"_"+operatortype);
  }
}
// ----------- Modefied by xwj on 2005-05-15 for td1838    E N D -------------------------


// ?????ù???????¤×÷?÷????????×?±ê????
sql = "SELECT nodeid , nodename , drawxpos, drawypos FROM workflow_flownode,workflow_nodebase WHERE (workflow_nodebase.IsFreeNode is null or workflow_nodebase.IsFreeNode!='1') and workflow_flownode.nodeid = workflow_nodebase.id and workflow_flownode.workflowid = "+workflowid;
rs.executeSql(sql);
    //System.out.println("sql = " + sql);
    //System.out.println("currentnodeid = " + currentnodeid);

while(rs.next()){
	icount ++;
    if(Util.null2String(rs.getString("nodeid")).equals(currentnodeid)){     // ?±?°????
        curnodetype = 1;
        bkcol = "#005979";
    }
    else if(operatednode.indexOf(Util.null2String(rs.getString("nodeid")))!=-1){  // ?????¨????????
        curnodetype = 0;
        bkcol = "#0079A4";
    }
    else {
        bkcol = "#00BDFF";          // ???ü????
        curnodetype =2;
    }

    int drawxpos = rs.getInt("drawxpos");
    int drawypos = rs.getInt("drawypos");
    String nodename = Util.toScreen(rs.getString("nodename"),user.getLanguage());
%>
<TABLE cellpadding=1 cellspacing=1 Class=ChartCompany
STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;
TOP:<%=drawypos-nodeysize+top0%>;LEFT:<%=drawxpos-nodexsize+left0%>;
height:<%=nodeysize*2%>;width:<%=nodexsize*2%>" LANGUAGE=javascript
onclick="return oc_CurrentMenuOnClick(<%=icount%>)" onmouseout="return oc_CurrentMenuonmouseout(<%=icount%>)" >
    <tr height=15px>
    <TD VALIGN=TOP style="padding-left:2px;background-color:<%=bkcol%>;color:white;border:1px solid black">
    <B><%=nodename%></B></TD>
    </TR><TR>
    <%
        if(Util.null2String(rs.getString("nodeid")).equals(currentnodeid)){
    %>
    <TD VALIGN=TOP align=left style="background-color:#F5F5F5;border:4px solid red;padding-left:2px">
    <%
        }else{
    %>
    <TD VALIGN=TOP align=left style="background-color:#F5F5F5;border:1px solid black;padding-left:2px">
    <%
        }
    %>
        <%if(curnodetype==0){%>
	<img src="/images/iconemp_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>">
		<%
            for(int i=0;i<operaternode.size();i++){
                String tmp = ""+operaternode.get(i);
                if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
                {
                    String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                    String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
	                if(tmptype.equals("0")){
    %>
	<a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                    }else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
                    }else{
    %>
	<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
	<%
                    }
            		break;
		        }
            }               //  end of for
    %>
	<br>&nbsp<br>
	<div align=right>
	>>>
	</div>
    <%
        } else if(curnodetype==1){
    %>
	<img src="/images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
	<%
            for(int i=0;i<canoperaternode.size();i++){
                String tmp = ""+canoperaternode.get(i);
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                String tmpid = tmp.substring(0,tmp.indexOf("_"));

                if(tmptype.equals("0")){
    %>
	<a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
                } else {
    %>
	<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
	<%
                }
		        break;
		    }               // end of for
    %>
	<br>&nbsp<br>
	<div align=right>
	>>>
	</div>
    <%
        }else if(curnodetype==2){
    %>
	<img src="/images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
	<%
	        sql = " select id , groupname from workflow_nodegroup where nodeid = " + rs.getString("nodeid");
	        rs1.executeSql(sql);
	        if(rs1.next()){
	%>
	<a href="/workflow/workflow/editoperatorgroup.jsp?isview=1&formid=<%=formid%>&isbill=<%=isbill%>&id=<%=rs1.getString("id")%>"><%=Util.toScreen(rs1.getString("groupname"),user.getLanguage())%></a>
	<%
            }
    %>
	<br>&nbsp<br>
	<div align=right>
	>>>
	</div>
    <%
        }
    %>
    </TD></TR></TABLE>

    <DIV id="oc_divMenuDivision<%=icount%>" name="oc_divMenuDivision<%=icount%>"
    style="visibility:hidden; LEFT:<%=drawxpos%>; POSITION:absolute; TOP:<%=drawypos+top0%>; WIDTH:240px; Z-INDEX: 200">
    <TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript
     onmouseout="return oc_CurrentMenuonmouseout(<%=icount%>)" onmouseover="return oc_CurrentMenuOnClick(<%=icount%>)"
     style="HEIGHT: 79px; WIDTH: 246px">
    <%
         if(curnodetype==0){
    %>
	 <TR id=D3><TD class=MenuPopup><img src="/images/iconemp_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>">
	<%
	        for(int i=0;i<operaternode.size();i++){
                String tmp = ""+operaternode.get(i);
                if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
                {
                    String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                    String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
                    if(tmptype.equals("0")){
    %>
	<a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                    } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
                    } else{
    %>
	<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
	<%
                    }
    %>
	&nbsp
	<%
                }
            }               // end of for
    %>
	&nbsp
	</TD></TR>
    <%
        } else if(curnodetype==1){
    %>
	<TR id=D1><TD class=MenuPopup><img src="/images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
	<%
            for(int i=0;i<canoperaternode.size();i++){
                String tmp = ""+canoperaternode.get(i);
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                String tmpid = tmp.substring(0,tmp.indexOf("_"));
	            if(tmptype.equals("0")){
    %>
	<a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
                } else{
    %>
	<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
	<%
                }
    %>
	&nbsp
	<%
            }       // end of for
    %>
	&nbsp
	</TD></TR>
	<TR id=D2><TD class=MenuPopup><img src="/images/icon_resource_flat_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16355,user.getLanguage())%>">
	<%
        for(int i=0;i<viewernode.size();i++){
            String tmp = ""+viewernode.get(i);
            String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
            String tmpid = tmp.substring(0,tmp.indexOf("_"));
            if(tmptype.equals("0")){
    %>
	<a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
            } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
            } else{
    %>
	<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
	<%
            }
    %>
	&nbsp
	<%
        }           // end of for
    %>
	&nbsp
	</TD></TR>
    <TR id=D3><TD class=MenuPopup><img src="/images/iconemp_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>">
	<%
        for(int i=0;i<operaternode.size();i++){
            String tmp = ""+operaternode.get(i);
            if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
            {
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
	            if(tmptype.equals("0")){
    %>
	<a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
                } else{
    %>
	<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
	<%
                }
    %>
	&nbsp
	<%
            }
        }           //  end of for
    %>
	&nbsp
	</TD></TR>
    <%
        } else if(curnodetype==2){
    %>
	<TR id=D1><TD class=MenuPopup><img src="/images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
	<%
	        sql = " select id, groupname from workflow_nodegroup where nodeid = " + rs.getString("nodeid");
	        rs1.executeSql(sql);
	        while(rs1.next()){
	%>
	<a href="/workflow/workflow/editoperatorgroup.jsp?isview=1&formid=<%=formid%>&isbill=<%=isbill%>&id=<%=rs1.getString("id")%>"><%=Util.toScreen(rs1.getString("groupname"),user.getLanguage())%></a>
	&nbsp
	<%
            }
    %>
	</TD></TR>
    <%
        }
    %>
</TABLE>
</DIV>

<%
}       // end of the max while
%>
</TD></TR></TABLE>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
<script type="text/javascript">
var imagehtml = document.all("InnerIMAGETD").innerHTML;
if(window.parent.document.all("divWfPic")) window.parent.document.all("divWfPic").innerHTML= imagehtml;
</script>
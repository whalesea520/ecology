<SCRIPT language=VBS>
Sub window_onload()
    wait.style.display="none"
    On Error Resume Next
    Baco.Refresh.focus
End Sub

Sub oc_CurrentMenuOnMouseOut(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = "hidden"
End Sub

Sub oc_CurrentMenuOnClick(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = ""
End Sub
</SCRIPT>

<script language="javascript">
function displaydiv()
{
    if(oDiv.style.display == ""){
        oDiv.style.display = "none";
        spanimage.innerHTML = "<img src='/images/ArrowDownRed_wev8.gif' border=0>" ;
    }
    else{
        spanimage.innerHTML = "<img src='/images/ArrowUpGreen_wev8.gif' border=0>" ;
        oDiv.style.display = "";
    }
}
</SCRIPT>


<div  id=oDiv style="display:none">
<img src = "/weaver/weaver.workflow.workflow.ShowWorkFlow?requestid=<%=requestid%>" border=0>
<%
int top0 = 38;   // 顶部空间
int nodexsize = 60;
int nodeysize = 40;
String currentnodeid="" + nodeid;

String bkcol = "";          // 节点方框颜色
int icount = 0;             // 节点计数
int curnodetype = 0;        // 节点状态  0: 已通过  1: 当前 2:其它

ArrayList operatednode = new ArrayList();               // 该工作流的所有已通过的节点
ArrayList operaternode = new ArrayList();               // 所有的非保存操作的操作者
ArrayList viewernode = new ArrayList();                 // 当前节点所有已查看者
ArrayList canoperaternode = new ArrayList();            // 当前节点的所有未操作者

 
/*  
logtype : 
1: 保存
2: 提交
3: 退回
4: 重新打开
5: 删除
6: 激活
9: 转发
*/

// 该工作流的所有已通过的节点 logtype = 2
sql = "select distinct nodeid from workflow_requestLog where logtype='2' and requestid = "+requestid;
rs.executeSql(sql);
while(rs.next())
{
	String nodeid1 = Util.null2String(rs.getString("nodeid"));
	operatednode.add(nodeid1);
}

// 当前节点所有已查看者
sql = "select distinct viewer,viewtype from workflow_requestViewLog where id = "+ requestid + " and currentnodeid = "+currentnodeid;
rs.executeSql(sql);
while(rs.next())
{
	String operator = Util.null2String(rs.getString("viewer"));
	String operatortype = Util.null2String(rs.getString("viewtype"));
	viewernode.add(operator+"_"+operatortype);
}

// 当前节点的所有未操作者
sql = "select distinct userid,usertype from workflow_currentoperator where isremark = '0' and requestid = "+ requestid ;
rs.executeSql(sql);
while(rs.next())
{
	String operator = Util.null2String(rs.getString("userid"));
	String operatortype = Util.null2String(rs.getString("usertype"));
	canoperaternode.add(operator+"_"+operatortype);
}

// 所有的非保存操作的操作者
sql = "select distinct nodeid,operator,operatortype from workflow_requestLog where requestid = "+requestid + " and logtype != '1' " ;
rs.executeSql(sql);
while(rs.next())
{
	String nodeid1 = Util.null2String(rs.getString("nodeid"));
	String operator = Util.null2String(rs.getString("operator"));
	String operatortype = Util.null2String(rs.getString("operatortype"));
	operaternode.add(nodeid1+"_"+operator+"_"+operatortype);
}

// 选出所有的该工作流的节点和坐标信息
sql = "SELECT nodeid , nodename , drawxpos, drawypos FROM workflow_flownode,workflow_nodebase WHERE (workflow_nodebase.IsFreeNode is null or workflow_nodebase.IsFreeNode!='1') and workflow_flownode.nodeid = workflow_nodebase.id and workflow_flownode.workflowid = "+workflowid;
rs.executeSql(sql);

while(rs.next()){
	icount ++;
    if(Util.null2String(rs.getString("nodeid")).equals(currentnodeid)){     // 当前节点
        curnodetype = 1;
        bkcol = "#005979";
    }
    else if(operatednode.indexOf(Util.null2String(rs.getString("nodeid")))!=-1){  // 已经通过的节点
        curnodetype = 0;
        bkcol = "#0079A4";
    }
    else {
        bkcol = "#00BDFF";          // 其它节点
        curnodetype =2;
    }
	
    int drawxpos = rs.getInt("drawxpos");
    int drawypos = rs.getInt("drawypos");
    String nodename = Util.toScreen(rs.getString("nodename"),user.getLanguage());
%>
<TABLE cellpadding=1 cellspacing=1 Class=ChartCompany 
STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;
TOP:<%=drawypos-nodeysize+top0%>;LEFT:<%=drawxpos-nodexsize%>;
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
	<img src="/images/iconemp_wev8.gif" title="已操作者">
		<%
            for(int i=0;i<operaternode.size();i++){
                String tmp = ""+operaternode.get(i);
                if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
                {
                    String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                    String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
	                if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%              
                    }else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%              
                    }else{
    %>
	系统
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
	<img src="/images/imgPersonHead_wev8.gif" title="未操作者">
	<%
            for(int i=0;i<canoperaternode.size();i++){
                String tmp = ""+canoperaternode.get(i);
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                String tmpid = tmp.substring(0,tmp.indexOf("_"));
	            
                if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
                } else {
    %>
	系统
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
	<img src="/images/imgPersonHead_wev8.gif" title="未操作者">
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
	 <TR id=D3><TD class=MenuPopup><img src="/images/iconemp_wev8.gif" title="已操作者">
	<%
	        for(int i=0;i<operaternode.size();i++){
                String tmp = ""+operaternode.get(i);
                if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
                {
                    String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                    String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
                    if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                    } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
                    } else{ 
    %>
	系统
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
	<TR id=D1><TD class=MenuPopup><img src="/images/imgPersonHead_wev8.gif" title="未操作者">
	<%
            for(int i=0;i<canoperaternode.size();i++){
                String tmp = ""+canoperaternode.get(i);
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                String tmpid = tmp.substring(0,tmp.indexOf("_"));
	            if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%          
                } else{
    %>
	系统
	<%
                }
    %>
	&nbsp
	<%
            }       // end of for
    %>
	&nbsp
	</TD></TR>
	<TR id=D2><TD class=MenuPopup><img src="/images/icon_resource_flat_wev8.gif" title="查看者">
	<%
        for(int i=0;i<viewernode.size();i++){
            String tmp = ""+viewernode.get(i);
            String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
            String tmpid = tmp.substring(0,tmp.indexOf("_"));
            if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
            } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
            } else{
    %>
	系统
	<%
            }
    %>
	&nbsp
	<%
        }           // end of for
    %>
	&nbsp
	</TD></TR>
    <TR id=D3><TD class=MenuPopup><img src="/images/iconemp_wev8.gif" title="已操作者">
	<%
        for(int i=0;i<operaternode.size();i++){
            String tmp = ""+operaternode.get(i);
            if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
            {
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
	            if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
                } else{
    %>
	系统
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
	<TR id=D1><TD class=MenuPopup><img src="/images/imgPersonHead_wev8.gif" title="未操作者">
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
</div>
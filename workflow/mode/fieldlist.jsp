
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<script language=javascript src="/js/weaver_wev8.js"></script>
<%

response.setHeader("X-UA-Compatible","IE=EmulateIE8");
int workflowid=Util.getIntValue(request.getParameter("wfid"),0);
int formid=Util.getIntValue(request.getParameter("formid"),0);
int nodeid=Util.getIntValue(request.getParameter("nodeid"),0);
int modeid=Util.getIntValue(request.getParameter("modeid"),0);
int isbill=Util.getIntValue(request.getParameter("isbill"),-1);
int isprint=Util.getIntValue(request.getParameter("isprint"),-1);
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK rel=stylesheet type=text/css HREF="chinaexcel_wev8.css">
<script language=javascript>
function stop () {
    <%if(user.getLanguage()==8){%>
    alert("<%=SystemEnv.getHtmlLabelName(84008 ,user.getLanguage())%>");
    <%}else if(user.getLanguage()==9){%>
    alert("<%=SystemEnv.getHtmlLabelName(84008 ,user.getLanguage())%>");
    <%}else{%>
    alert("<%=SystemEnv.getHtmlLabelName(84008 ,user.getLanguage())%>");
    <%}%>
return false;
}
document.oncontextmenu=stop;
</script>
<TITLE> </TITLE>

<style>

div{
    height:10;PADDING:4px 2;BACKGROUND-COLOR:#ffffff;cursor:hand;font-size: 12;border:1px groove #cccccc;
    margin:1px;
    }
div table td {
	padding:2px;
}
</style>

</HEAD>

<BODY style="BACKGROUND-COLOR:buttonface;MARGIN:0">
<table id="fieldtable" style="HEIGHT:100%;WIDTH:100%;PADDING:0px;BACKGROUND-COLOR:buttonface;border:1px solid #666666;" cellpadding='0' height=100% width=100% cellspacing='0'>
<tr><td valign="top" style="heigth:100%;WIDTH:100%;">
<div style="BACKGROUND-COLOR:buttonface;cursor:text">
<table height=15 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="height:15;font-size: 15;font-weight: bold;"><%=SystemEnv.getHtmlLabelName(18020,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="requestname" value="<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="requestlevel" value="<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="messageType" value="<%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%>" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="chatsType" value="<%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%>" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="qianzi" value="<%=SystemEnv.getHtmlLabelName(1007,user.getLanguage())%>" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(1007,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="main_showKeyword" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(21517,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="main_createCodeAgain" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(22784,user.getLanguage())%>
</td></tr>
</table>
</div>
<%
RecordSet.executeSql("select nodetype from workflow_flownode where nodeid="+nodeid);
String nodetype = "";
if(RecordSet.next()){
	nodetype = RecordSet.getString("nodetype");
}
ArrayList mantablefields=new ArrayList();
ArrayList mantablefieldnames=new ArrayList();
ArrayList detailtablefields=new ArrayList();
ArrayList detailtablefieldnames=new ArrayList();
ArrayList nodes=new ArrayList();
ArrayList nodenames=new ArrayList();

FieldInfo.GetManTableField(formid,isbill,user.getLanguage());
FieldInfo.GetDetailTableField(formid,isbill,user.getLanguage());
FieldInfo.GetWorkflowNode(workflowid);

mantablefields=FieldInfo.getManTableFields();
mantablefieldnames=FieldInfo.getManTableFieldNames();
detailtablefields=FieldInfo.getDetailTableFields();
detailtablefieldnames=FieldInfo.getDetailTableFieldNames();
nodes=FieldInfo.getNodes();
nodenames=FieldInfo.getNodeNames();
for(int i=0; i<mantablefields.size();i++){
%>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="<%=mantablefields.get(i)%>" value="<%=mantablefieldnames.get(i)%>" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top">
<%=mantablefieldnames.get(i)%>
</td></tr>
</table>
</div>
<%
}%>
<div style="BACKGROUND-COLOR:buttonface;cursor:text">
<table height=15 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="height:15;font-size: 15;font-weight: bold;"><%=SystemEnv.getHtmlLabelName(18021,user.getLanguage())%>
</td></tr>
</table>
</div>
<%
for(int i=0;i<detailtablefields.size();i++){
%>
<div style="BACKGROUND-COLOR:buttonface;cursor:text">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="font-size: 12;font-weight: bold;" >
<%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%><%=i+1%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="detail<%=i%>_add" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(19569,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="detail<%=i%>_del" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(19570,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="detail<%=i%>_sel" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(19571,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="detail<%=i%>_head" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(19572,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="detail<%=i%>_end" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(19573,user.getLanguage())%>
</td></tr>
</table>
</div>
<%if(isprint==1){%>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="detail<%=i%>_isprintbegin" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(22364,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="detail<%=i%>_isprintend" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(22365,user.getLanguage())%>
</td></tr>
</table>
</div>
<%}%>
<%if(!nodetype.equals("3")){%>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="detail<%=i%>_isneed" value="<%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%>" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%>
</td></tr>
</table>
</div>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="detail<%=i%>_isdefault" value="<%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%>" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="color:#FF00FF">
<%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%>
</td></tr>
</table>
</div>
<%}%>
<%
    ArrayList tempdetails=(ArrayList)detailtablefields.get(i);
    ArrayList tempdetailnames=(ArrayList)detailtablefieldnames.get(i);
    for(int j=0;j<tempdetails.size();j++){
%>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="<%=tempdetails.get(j)%>" value="<%=tempdetailnames.get(j)%>" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top">
<%=tempdetailnames.get(j)%>
</td></tr>
</table>
</div>
<%
    }
}
%>

<div style="BACKGROUND-COLOR:buttonface;cursor:text">
<table height=15 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top" style="height:15;font-size: 15;font-weight: bold;"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%>
</td></tr>
</table>
</div>
<%
for(int i=0;i<nodes.size();i++){
%>
<div onmouseover="this.style.background='#CCFF66'" onmouseout="this.style.background='#ffffff'" id="<%=nodes.get(i)%>"  value="<%=nodenames.get(i)%>" onclick="setcellval(this)">
<table height=10 width=100% cellpadding='0' cellspacing='0'>
<tr><td valign="top">
<%=nodenames.get(i)%>
</td></tr>
</table>
</div>
<%
}
%>
</td></tr>
</table>
<script language=vbs>
sub setcellval(obj)
    Dim nCombiRows
    nowrow=parent.chinaexcel.CellWeb1.Row
    nowcol=parent.chinaexcel.CellWeb1.Col
    userstring=parent.chinaexcel.CellWeb1.GetCellUserStringValue(nowrow,nowcol)  
    cellval=parent.chinaexcel.CellWeb1.GetCellValue(nowrow,nowcol)
    strname=obj.id
    if InStr(userstring,"_head")>0 or InStr(userstring,"_end")>0 then
    exit sub
    end if
    if InStr(strname,"_head")<1 and InStr(strname,"_end")<1 and InStr(strname,"_isprintbegin")<1 and InStr(strname,"_isprintend")<1 then
        parent.chinaexcel.CellWeb1.SetCellProtect nowrow,nowcol,nowrow,nowcol,false
        if Len(userstring)>0 then            
            document.getElementById(userstring).style.display=""
            parent.chinaexcel.CellWeb1.DeleteCellImage nowrow,nowcol,nowrow,nowcol
        end if
        parent.chinaexcel.CellWeb1.SetCellNormalType nowrow,nowcol
        //parent.chinaexcel.CellWeb1.HorzTextAlign = 2
        parent.chinaexcel.CellWeb1.SetCellUserStringValue nowrow,nowcol,nowrow,nowcol,strname
        if strname="requestname" then
        <%
		    if(nodetype.equals("0")){
	    	%>
        	parent.chinaexcel.CellWeb1.SetCellUserValue nowrow,nowcol,nowrow,nowcol,2
        	parent.chinaexcel.CellWeb1.ReadHttpImageFile "/images/BacoError_wev8.gif",nowrow,nowcol,true,true
        <%}else{%>
        	parent.chinaexcel.CellWeb1.SetCellUserValue nowrow,nowcol,nowrow,nowcol,0
        <%}%> 
        else parent.chinaexcel.CellWeb1.SetCellUserValue nowrow,nowcol,nowrow,nowcol,0
        end if
    end if
    if InStr(strname,"_add")>0 then
        parent.chinaexcel.CellWeb1.HorzTextAlign = 2
        parent.chinaexcel.CellWeb1.SetCellVal nowrow,nowcol,"<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>"
        parent.chinaexcel.CellWeb1.ReadHttpImageFile "/images/addDocs_wev8.gif",nowrow,nowcol,true,false        
    else
        if InStr(strname,"_del")>0 then
            parent.chinaexcel.CellWeb1.HorzTextAlign = 2
            parent.chinaexcel.CellWeb1.SetCellVal nowrow,nowcol,"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"
            parent.chinaexcel.CellWeb1.ReadHttpImageFile "/images/addDocs_wev8.gif",nowrow,nowcol,true,false
        else
            if InStr(strname,"_sel")>0 then
                parent.chinaexcel.CellWeb1.SetCellVal nowrow,nowcol,""
                parent.chinaexcel.CellWeb1.SetCellCheckBoxType nowrow,nowcol
            else
                if InStr(strname,"_head")>0 then
                    if nowrow>1 then
                    parent.chinaexcel.CellWeb1.InsertNextRow nowrow-1,nowrow-1
                    parent.chinaexcel.CellWeb1.SetCellBkColor nowrow,1,nowrow,1,15527148
                    parent.chinaexcel.CellWeb1.CombiNation nowrow,nowrow,1,parent.chinaexcel.CellWeb1.GetMaxCol                    
                    parent.chinaexcel.CellWeb1.SetCellVal nowrow,1,"【$<%=SystemEnv.getHtmlLabelName(19572,user.getLanguage())%>】"
                    parent.chinaexcel.CellWeb1.SetCellUserStringValue nowrow,1,nowrow,1,strname
                    parent.chinaexcel.CellWeb1.GoToCell nowrow,1
                    else
                    msgbox "<%=SystemEnv.getHtmlLabelName(19574,user.getLanguage())%>"
                    Exit Sub
                    end if
                else
                    if InStr(strname,"_end")>0 then
                        parent.chinaexcel.CellWeb1.GetCellCombiNationWeb nowrow,nowcol,StartCombiRow,StartCombiCol,nCombiRows,nCombiCols
                        parent.chinaexcel.CellWeb1.InsertNextRow nowrow+nCombiRows,nowrow+nCombiRows    
                        parent.chinaexcel.CellWeb1.SetCellBkColor nowrow+nCombiRows+1,1,nowrow+nCombiRows+1,parent.chinaexcel.CellWeb1.GetMaxCol,15527148
                        parent.chinaexcel.CellWeb1.CombiNation nowrow+nCombiRows+1,nowrow+nCombiRows+1,1,parent.chinaexcel.CellWeb1.GetMaxCol                        
                        parent.chinaexcel.CellWeb1.SetCellVal nowrow+nCombiRows+1,1,"【$<%=SystemEnv.getHtmlLabelName(19573,user.getLanguage())%>】"
                        parent.chinaexcel.CellWeb1.SetCellUserStringValue nowrow+nCombiRows+1,1,nowrow+nCombiRows+1,1,strname
                        parent.chinaexcel.CellWeb1.GoToCell nowrow+nCombiRows+1,1
                    else 
                        if InStr(strname,"_isprintbegin")>0 then
                         	  if nowrow>1 then
                                parent.chinaexcel.CellWeb1.InsertNextRow nowrow-1,nowrow-1
                                parent.chinaexcel.CellWeb1.SetCellBkColor nowrow,1,nowrow,1,15527148
                                parent.chinaexcel.CellWeb1.CombiNation nowrow,nowrow,1,parent.chinaexcel.CellWeb1.GetMaxCol                    
                                parent.chinaexcel.CellWeb1.SetCellVal nowrow,1,"【$<%=SystemEnv.getHtmlLabelName(22364,user.getLanguage())%>】"
                                parent.chinaexcel.CellWeb1.SetCellUserStringValue nowrow,1,nowrow,1,strname
                                parent.chinaexcel.CellWeb1.GoToCell nowrow,1
                            else
                                msgbox "<%=SystemEnv.getHtmlLabelName(19574,user.getLanguage())%>"
                                Exit Sub
                            end if
                        else if InStr(strname,"_isprintend")>0 then
                         	  if nowrow>1 then
                                parent.chinaexcel.CellWeb1.GetCellCombiNationWeb nowrow,nowcol,StartCombiRow,StartCombiCol,nCombiRows,nCombiCols
                                parent.chinaexcel.CellWeb1.InsertNextRow nowrow+nCombiRows,nowrow+nCombiRows    
                                parent.chinaexcel.CellWeb1.SetCellBkColor nowrow+nCombiRows+1,1,nowrow+nCombiRows+1,parent.chinaexcel.CellWeb1.GetMaxCol,15527148
                                parent.chinaexcel.CellWeb1.CombiNation nowrow+nCombiRows+1,nowrow+nCombiRows+1,1,parent.chinaexcel.CellWeb1.GetMaxCol                        
                                parent.chinaexcel.CellWeb1.SetCellVal nowrow+nCombiRows+1,1,"【$<%=SystemEnv.getHtmlLabelName(22365,user.getLanguage())%>】"
                                parent.chinaexcel.CellWeb1.SetCellUserStringValue nowrow+nCombiRows+1,1,nowrow+nCombiRows+1,1,strname
                                parent.chinaexcel.CellWeb1.GoToCell nowrow+nCombiRows+1,1
                            else
                                msgbox "<%=SystemEnv.getHtmlLabelName(19574,user.getLanguage())%>"
                                Exit Sub
                            end if
                        else 
                        if InStr(strname,"showKeyword")>0 then
                            parent.chinaexcel.CellWeb1.HorzTextAlign = 2
                            parent.chinaexcel.CellWeb1.SetCellVal nowrow,nowcol,""
                            parent.chinaexcel.CellWeb1.ReadHttpImageFile "/images/BacoBrowser_wev8.gif",nowrow,nowcol,true,true
						else
                            if InStr(strname,"createCodeAgain")>0 then
                                parent.chinaexcel.CellWeb1.HorzTextAlign = 2
                                parent.chinaexcel.CellWeb1.SetCellVal nowrow,nowcol,""
                                parent.chinaexcel.CellWeb1.ReadHttpImageFile "/images/BacoBrowser_wev8.gif",nowrow,nowcol,true,true
						    else						
                                if InStr(cellval,"@")<1 then                        
                                    parent.chinaexcel.CellWeb1.SetCellVal nowrow,nowcol,"【$"&obj.value&"】"
                                end if
							end if
						end if
                    end if
                    end if
                    end if
                end if
            end if
        end if
    end if
    if InStr(strname,"_head")<1 and InStr(strname,"_end")<1 and InStr(strname,"_isprintbegin")<1 and InStr(strname,"_isprintend")<1 then
    parent.chinaexcel.CellWeb1.SetCellProtect nowrow,nowcol,nowrow,nowcol,true
    else
        if InStr(strname,"_head")>0 or InStr(strname,"_isprintbegin")>0 then
            parent.chinaexcel.CellWeb1.SetCellProtect nowrow,1,nowrow,1,true
        else
            parent.chinaexcel.CellWeb1.SetCellProtect nowrow+nCombiRows+1,1,nowrow+nCombiRows+1,1,true
        end if
    end if
    if InStr(cellval,"@")>0 then
        parent.chinaexcel.CellWeb1.SetCellProtect nowrow,nowcol,nowrow,nowcol,false
    end if
    parent.chinaexcel.CellWeb1.RefreshViewSize
    obj.style.display="none"
end sub
</script>

</BODY>
</HTML>

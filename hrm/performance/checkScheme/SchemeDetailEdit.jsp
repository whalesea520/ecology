<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsn" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsg" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="rss" class="weaver.conn.RecordSet" scope="page" />
<% if(!HrmUserVarify.checkUserRight("CheckScheme:Performance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   } 
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String contentId=Util.null2String(request.getParameter("contentId"));
String id=Util.null2String(request.getParameter("id"));
String type=Util.null2String(request.getParameter("type"));
String cycle=Util.null2String(request.getParameter("cycle"));
String mainid=Util.null2String(request.getParameter("mainid"));
String percent_n="";
String item="";
String checkFlow="";
String workflowname="";
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18064,user.getLanguage());
String needfav ="1";
String needhelp ="";
String titlenamet="";
if (type.equals("0")) {
titlenamet="-"+SystemEnv.getHtmlLabelName(18060,user.getLanguage());
}
if (type.equals("1")) {
titlenamet="-"+SystemEnv.getHtmlLabelName(18061,user.getLanguage());
}
if (type.equals("2")) {
titlenamet="-"+SystemEnv.getHtmlLabelName(18062,user.getLanguage());
}
titlename+=titlenamet;
//用来判断自定义考核项的指数和不大于100%,(目标考核非月度考核也要判断)
if (rss.getDBType().equals("oracle"))
rss.execute("select sum(percent_n) from HrmPerformanceSchemeDetail where contentId="+contentId+" and id!="+id);
else if (rss.getDBType().equals("db2"))
rss.execute("select sum(double(percent_n)) from HrmPerformanceSchemeDetail where contentId="+contentId+" and id!="+id);
else
rss.execute("select sum(convert(float,percent_n)) from HrmPerformanceSchemeDetail where contentId="+contentId+" and id!="+id);
float sum=0;
if (rss.next())
{
  sum=Util.getFloatValue(Util.null2o(rss.getString(1)));
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CheckSchemeEdit.jsp?id="+mainid+"&cycle="+cycle+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;

rs.execute("select a.*,b.workflowname from HrmPerformanceSchemeDetail a left join workflow_base  b on a.checkFlow=b.id where a.id="+id);
if (rs.next())
{
 percent_n=Util.null2String(rs.getString("percent_n"));
 item=Util.null2String(rs.getString("item"));
 checkFlow=Util.null2String(rs.getString("checkFlow"));
 workflowname=Util.null2String(rs.getString("workflowname"));
}
%>	

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM name=resource id=resource action="CheckSchemeOperation.jsp" method=post>
<input type=hidden name=edittype value=detail>
<input type=hidden name=contentId value=<%=contentId%>>
<input type=hidden name=id value=<%=id%>>
<input type=hidden name=type value=<%=type%>>
<input type=hidden name=cycle value=<%=cycle%>>
<input type=hidden name=mainid value=<%=mainid%>>
<input type=hidden name=sum value=<%=sum%>>
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="10%"> 
    <COL width="90%"> 
    <TBODY> 
  
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=90%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
           <%if (type.equals("0")) {%>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18064 ,user.getLanguage())%></TD>
            <TD class=Field> 
             <select class=inputstyle name="item" id="item">
             <%if (!cycle.equals("3")) {%><option value="0" <%if (item.equals("0")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18170 ,user.getLanguage())%></option>
             <%}%>
             <%if (!cycle.equals("2")) {%><option value="1" <%if (item.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18137 ,user.getLanguage())%></option>
             <%}%>
             </select>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <%}%>
        <%if (type.equals("1")) {%>
              <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18048 ,user.getLanguage())%></TD>
            <TD class=Field> 
           <BUTTON type="button" class=Browser id=SelectCheckID onClick="onShowCheck()"></BUTTON> 
              <span 
            id=checkidspan>
            <%rsd.execute("select * from HrmPerformanceCheckRule where id="+item);
            if (rsd.next())
            {
            out.print(Util.toScreen(rsd.getString("ruleName"),user.getLanguage()));
            }
            %>
            </span> 
              <INPUT class=inputStyle id=checkItem 
            type=hidden name=checkItem value=<%=item%>>
            </TD>
          </TR>
             <%}%>
             <%if (type.equals("2")) {%>
             <!-- TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18062 ,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(857 ,user.getLanguage())%></TD>
            <TD class=Field> 
            <BUTTON class=Browser id=SelectDocID onClick="onShowDoc()"></BUTTON> 
              <span 
            id=docidspan>
            <%
            DocComInfo.addDocInfoCache(item);
            out.print(DocComInfo.getDocname(item)) ;
            %></span> 
              <INPUT class=inputStyle id=docItem 
            type=hidden name=docItem value=<%=item%> >
            </TD>
          </TR-->
             <%}%>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6071 ,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=4 size=4 value="<%=percent_n%>"
            name="percent_n"  onchange='checkinput("percent_n","nameimage");checknumber("percent_n")' >%
            <SPAN id=nameimage>
			<%if (percent_n.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN> 
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18067,user.getLanguage())%></TD>
            <TD class=Field> 
              <!-- BUTTON class=Browser id=SelectFlowID onClick="onShowFlowID()"></BUTTON--> 
              <span 
            id=flowidspan>
            <%=workflowname%>
            </span> 
              <INPUT class=inputStyle id=checkFlow 
            type=hidden name=checkFlow value=<%=checkFlow%> >
           
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
</tr>
</TABLE>
<!-- 评分权重-->
 <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="10%"> 
    <COL width="90%"> 
    <TBODY> 
    <TR> 
      <TD vAlign=top> 
          <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=90%><TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18134,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <tr><th align="left">
          <%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%> 
          <th align="left">
          <%=SystemEnv.getHtmlLabelName(18134,user.getLanguage())%> 
          </th>
          </th></tr>
         
          <%
          int i=0;
         
          rsn.execute("SELECT d.percent_n,b.workflowid, b.nodeid, c.checkFlow, c.item, a.nodename FROM workflow_nodebase a LEFT OUTER JOIN "+
                         "workflow_flownode b ON (a.IsFreeNode is null or a.IsFreeNode!='1') and a.id = b.nodeid LEFT OUTER JOIN "+
                        "HrmPerformanceSchemeDetail c ON b.workflowid = c.checkFlow "+
                        "left join HrmPerformanceSchemePercent d on c.id=d.itemId and a.id=d.nodeId and d.type_d='0' and d.type_n='0'"+
                         " WHERE c.id="+id+" and b.nodetype!='0' and b.nodetype!='3' ORDER BY a.id");
                        
                         
          while (rsn.next())
          {
          i++;
          %>
           <TR> 
            <TD><%=Util.toScreen(Util.null2String(rsn.getString("nodename")),user.getLanguage())%></TD>
            <TD class=Field > 
              <input type="hidden" name="nodeId_<%=i%>" value=<%=rsn.getString("nodeid")%>>
              <input class=inputstyle name="percent_n<%=i%>" type="text" value="<%=rsn.getString("percent_n")%>" maxlength=4 size=4 onchange='checknumber("percent_n<%=i%>");checkinput("percent_n<%=i%>","sp<%=i%>")'>%
              <span id="sp<%=i%>">
              <%if (rsn.getString("percent_n").equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle> <%}%></span>
              </span>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <%
          
          int j=0;
          rsg.execute("select a.* ,d.percent_n from workflow_nodegroup a  left join HrmPerformanceSchemePercent d on a.id=d.groupId and d.type_n='1' and d.type_d='0' and d.itemId="+id+" where   a.nodeid="+rsn.getString("nodeid")+" order by a.id ");
          while (rsg.next())
          {
          j++;
          %>
          <TR> 
            <td></td>
            <TD class=Field><%=SystemEnv.getHtmlLabelName(15545,user.getLanguage())%>: <%=Util.toScreen(Util.null2String(rsg.getString("groupname")),user.getLanguage())%>　　
              <input type="hidden" name="nodeId_<%=i%>_groupId_<%=j%>" value=<%=rsg.getString("id")%>>
              <%=SystemEnv.getHtmlLabelName(18134,user.getLanguage())%>:<input class=inputstyle name="nodeId_<%=i%>_percent_ng<%=j%>" type="text" value="<%=rsg.getString("percent_n")%>" maxlength=4 size=4 onchange='checknumber("nodeId_<%=i%>_percent_ng<%=j%>");checkinput("nodeId_<%=i%>_percent_ng<%=j%>","nodeId_<%=i%>_spg<%=j%>")'>%
             <span id="nodeId_<%=i%>_spg<%=j%>">
             <%if (rsg.getString("percent_n").equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle> <%}%>
             </span>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <%
          }
          %>
          <input type="hidden" name="nodeId_<%=i%>_grouplength" value="<%=j%>" >
          <%} %> 
           <input type="hidden" name="nodelength" value="<%=i%>" >
           
          
          </TBODY>
          </TABLE>
       </TD>
     </tr>
      </table>
      <!-- 评分权重结束-->
      
  <!-- 评分权重(含下游)-->
  <%if (type.equals("0")&&item.equals("0")) {%>
 <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="10%"> 
    <COL width="90%"> 
    <TBODY> 
    <TR> 
      <TD vAlign=top> 
          <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=90%><TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18135,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <tr><th align="left">
          <%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%> 
          <th align="left">
          <%=SystemEnv.getHtmlLabelName(18134,user.getLanguage())%> 
          </th>
          </th></tr>
         
          <%
          i=0;
         
          rsn.execute("SELECT d.percent_n,b.workflowid, b.nodeid, c.checkFlow, c.item, a.nodename FROM workflow_nodebase a LEFT OUTER JOIN "+
                         "workflow_flownode b ON (a.IsFreeNode is null or a.IsFreeNode!='1') and a.id = b.nodeid LEFT OUTER JOIN "+
                        "HrmPerformanceSchemeDetail c ON b.workflowid = c.checkFlow "+
                        "left join HrmPerformanceSchemePercent d on c.id=d.itemId and a.id=d.nodeId and d.type_d='1' and d.type_n='0'"+
                         " WHERE c.id="+id+" and b.nodetype!='0' and b.nodetype!='3' ORDER BY a.id");
                    
          while (rsn.next())
          {
          i++;
          %>
           <TR> 
            <TD><%=Util.toScreen(Util.null2String(rsn.getString("nodename")),user.getLanguage())%></TD>
            <TD class=Field > 
              <input type="hidden" name="dnodeId_<%=i%>" value=<%=rsn.getString("nodeid")%>>
              <input class=inputstyle name="dpercent_n<%=i%>" type="text"  value="<%=rsn.getString("percent_n")%>" maxlength=4 size=4 onchange='checknumber("dpercent_n<%=i%>");checkinput("dpercent_n<%=i%>","dsp<%=i%>")'>%
              <span id="dsp<%=i%>">
              <%if (rsn.getString("percent_n").equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle> <%}%></span>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <%
          
          int  j=0;
          rsg.execute("select a.*,d.percent_n from workflow_nodegroup a  left join HrmPerformanceSchemePercent d on a.id=d.groupId and d.type_n='1' and d.type_d='1' and d.itemId="+id+" where  a.nodeid="+rsn.getString("nodeid")+" order by a.id ");
          while (rsg.next())
          {
          j++;
          %>
          <TR> 
            <td></td>
            <TD class=Field><%=SystemEnv.getHtmlLabelName(15545,user.getLanguage())%>: <%=Util.toScreen(Util.null2String(rsg.getString("groupname")),user.getLanguage())%>　　
              <input type="hidden" name="dnodeId_<%=i%>_groupId_<%=j%>" value=<%=rsg.getString("id")%>>
              <%=SystemEnv.getHtmlLabelName(18134,user.getLanguage())%>:<input class=inputstyle name="dnodeId_<%=i%>_percent_ng<%=j%>" type="text" value="<%=rsg.getString("percent_n")%>" maxlength=4 size=4 onchange='checknumber("dnodeId_<%=i%>_percent_ng<%=j%>");checkinput("dnodeId_<%=i%>_percent_ng<%=j%>","dnodeId_<%=i%>_spg<%=j%>")'>%
             <span id="dnodeId_<%=i%>_spg<%=j%>">
             <%if (rsg.getString("percent_n").equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
             </span>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <%
          }
          %>
          <input type="hidden" name="dnodeId_<%=i%>_grouplength" value="<%=j%>" >
          <%} %> 
           <input type="hidden" name="dnodelength" value="<%=i%>" >
            <%
            String down="";
            rsg.execute("select * from  HrmPerformanceSchemePercent where type_n='2' and itemId="+id);
            if  (rsg.next())
            {
            down=rsg.getString("percent_n");
            }
          %>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18176,user.getLanguage())%></TD>
            <TD class=Field > 
              <input class=inputstyle name="downnode" type="text" value="<%=down%>" maxlength=4 size=4 onchange='checknumber("downnode");checkinput("downnode","downsp")'>%
              <span id="downsp">
              <%if (down.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
              </span>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY>
          </TABLE>
       </TD>
     </tr>
      </table>
      <!-- 评分权重结束-->
      <%}%>
</FORM>
</td>
<td></td>
</tr>

<tr>
<td height="10" colspan="3"></td>
</tr>
</table>


<SCRIPT language="javascript">
function OnSubmit(){
     if (<%=type%>=="0"&&<%=item%>=="0")
     {
	    if(check_form(document.resource,"percent_n,checkFlow")&&checkall()&&dcheckall())
		{	
			document.resource.submit();
			enablemenu();
			
		}
	}
	else
	{
		if(check_form(document.resource,"percent_n,checkFlow")&&checkall())
		{	
			document.resource.submit();
			enablemenu();
			
		}
	}
}
function checkall()
{
a=parseFloat(document.all("nodelength").value);
sum=0
sum1=0;
       if (<%=type%>=="2")
	     {
	     if (parseFloat(document.resource.percent_n.value)!=100) 
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18062,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(18179,user.getLanguage())%>");
	     return;
	     }
	     }
	     if ((<%=type%>=="0")&&(<%=cycle%>=="2"))
	     {
	     if (parseFloat(document.resource.percent_n.value)!=100) 
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18136,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(18179,user.getLanguage())%>");
	     return;
	     }
	     }
	     if ((<%=type%>=="1"))
	     {
	     if ((parseFloat(document.resource.percent_n.value)+parseFloat(document.resource.sum.value))>100)
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18061,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(15223,user.getLanguage())%>"+100);
	     return;
	     }
	     }
	     if ((<%=type%>=="0"&&<%=cycle%>!="2"))
	     {
	     if ((parseFloat(document.resource.percent_n.value)+parseFloat(document.resource.sum.value))>100) 
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18060,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(15223,user.getLanguage())%>"+100);
	     return;
	     }
	     }
    
for (i=1;i<=a;i++)
{	
if (document.all("percent_n"+i).value=="")
  {
   alert("<%=SystemEnv.getHtmlLabelName(18138,user.getLanguage())%>");
   return false;
  }
  else
  {
  sum=sum+parseFloat(document.all("percent_n"+i).value);
  }
 
  b=parseFloat(document.all("nodeId_"+i+"_grouplength").value);
   sum1=0;
   
   if (b>0)
   {
   for(j=1;j<=b;j++)
   { 
    if (document.all("nodeId_"+i+"_percent_ng"+j).value=="")
    {alert("<%=SystemEnv.getHtmlLabelName(18138,user.getLanguage())%>");
     return false;}
    else
    {
    sum1=sum1+parseFloat(document.all("nodeId_"+i+"_percent_ng"+j).value);
    }
   }
   if (sum1!=100) 
   {
    alert("<%=SystemEnv.getHtmlLabelName(18174,user.getLanguage())%>");
    return false;
   }
   }
}
if (sum!=100)
{
    alert("<%=SystemEnv.getHtmlLabelName(18175,user.getLanguage())%>");
    return false;
}
return true;
}

function dcheckall()  //含下游节点的脚本
{
a=parseFloat(document.all("dnodelength").value);
sum=0
sum1=0;

    
for (i=1;i<=a;i++)
{	
if (document.all("dpercent_n"+i).value=="")
  {
   alert("<%=SystemEnv.getHtmlLabelName(18138,user.getLanguage())%>");
   return false;
  }
  else
  {
  sum=sum+parseFloat(document.all("dpercent_n"+i).value);
  }
 
  b=parseFloat(document.all("dnodeId_"+i+"_grouplength").value);
   sum1=0;
   for(j=1;j<=b;j++)
   { 
    if (document.all("dnodeId_"+i+"_percent_ng"+j).value=="")
    {alert("<%=SystemEnv.getHtmlLabelName(18138,user.getLanguage())%>");
     return false;}
    else
    {
    sum1=sum1+parseFloat(document.all("dnodeId_"+i+"_percent_ng"+j).value);
    }
   }
   if (sum1!=100) 
   {
    alert("<%=SystemEnv.getHtmlLabelName(18174,user.getLanguage())%>");
    return false;
   }
}
d=document.all("downnode").value;
if (d=="")
{
alert("<%=SystemEnv.getHtmlLabelName(18176,user.getLanguage())%>");
return false;
}
sum=sum+parseFloat(d);
if (sum!=100)
{
    alert("<%=SystemEnv.getHtmlLabelName(18175,user.getLanguage())%>");
    return false;
}
return true;
}

function onShowCheck(){ 
    result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/maintenance/diyCheck/CheckBrowser.jsp")
	if (result){
	if (result.id != ""){
		checkidspan.innerHTML =result.name;
		resource.checkItem.value=result.id;
	}else{
		checkidspan.innerHTML = "<img src='/images/BacoError.gif' align=absMiddle>";
		resource.checkItem.value="";
	}
	}
}

 
function onShowFlowID() {
    result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/FlowBrowser.jsp")
	if(result){
		if(result[0]!=''){
			flowidspan.innerHTML = result[1];
			resource.checkFlow.value=result[0];
		}else{
			flowidspan.innerHTML = "<img src='/images/BacoError.gif' align=absMiddle>"
			resource.checkFlow.value=""
		}
	}
}

function onShowDoc() {
     result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if(result){
		if(result.id!=''){
			flowidspan.innerHTML = result.name;
			resource.checkFlow.value=result.id
		}else{
			flowidspan.innerHTML = "<img src='/images/BacoError.gif' align=absMiddle>"
			resource.checkFlow.value=""
		}
	}
}
</SCRIPT>

</BODY>
</HTML>
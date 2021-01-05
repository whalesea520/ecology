<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*,
				weaver.hrm.train.TrainLayoutComInfo,
				weaver.hrm.train.TrainPlanComInfo,
				weaver.conn.RecordSet
				" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<html>
<%!
	/**
	* May 31,2004
	* @author Charoes Huang
	* @Description: 判断该培训安排是否可以申请
	*/
	private boolean canApplyTrain(String planid,String resourceid){
		boolean canApply = false;
		TrainPlanComInfo comInfo = new TrainPlanComInfo();
		ArrayList a_trainPlan = comInfo.getTrainPlanByResource(resourceid);
		if(a_trainPlan.indexOf(planid) != -1){
			canApply = true;
		}		
		return canApply;
	}
	/*June 2,2004
	 *@author Charoes Huang
	 *@Description 是否是参与人
	*/
	private boolean isActor(String id,String resourceid){
	  ArrayList al = new ArrayList();
	  try{
		  String sql = "select planactor from HrmTrainPlan where id ='"+id+"'";
		  RecordSet rs = new RecordSet();
		  rs.executeSql(sql);
		  rs.next();
		  String actors = Util.null2String(rs.getString("planactor"));
		  al = Util.TokenizerString(actors,",");
		  for(int i =0;i<al.size();i++){
			  String actor = (String)al.get(i);
			  if(actor.equals(resourceid)){
				  return true;
			  }
		  }
	  }catch(Exception e){
		  
	  }
	  return false;
  }
%>
<%
Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
                 
String id = request.getParameter("id");	

boolean canView = false;
/*
canView = TrainPlanComInfo.isViewer(id,""+user.getUID());
if(HrmUserVarify.checkUserRight("HrmTrainPlanEdit:Edit", user)){
   canView = true;
}
*/
boolean isActor = false;
isActor = isActor(id,""+user.getUID()); //是否时参与人

boolean canApply = canApplyTrain(id,""+user.getUID()); /*Added by Charoes Huang ; May 31,2004*/

/*boolean isOperator = TrainPlanComInfo.isPlanOperator(id,user.getUID()); 
//Modified By Charoes Huang ,May 31,2004 ; 只有组织人和创建人可以编辑公开范围和通知*/
boolean isOperator = TrainPlanComInfo.isOperator(id,user.getUID());
if(!canApply && !isOperator && !isActor){
  response.sendRedirect("/notice/noright.jsp");
  return;
}
boolean canEdit = TrainPlanComInfo.canEdit(id);

boolean isend = TrainPlanComInfo.isEnd(id);

int userid = user.getUID();
TrainLayoutComInfo tl = new TrainLayoutComInfo();

  String name = "";
  String layoutid = "";
  String organizer = "";
  String startdate="";
  String enddate = "";
  String content="";
  String aim = "";  
  String address = "";
  String resource = ""; 
  String actor = ""; 
  String budget = "";
  String budgettype = ""; 
  String openrange = "";
  String docs="";
  String docsShowname="";
  String sql = "select * from HrmTrainPlan where id = "+id;
  rs.executeSql(sql);
  if(rs.next()){
     name = Util.null2String(rs.getString("planname"));
     layoutid = Util.null2String(rs.getString("layoutid"));
     organizer = Util.null2String(rs.getString("planorganizer"));
     startdate = Util.null2String(rs.getString("planstartdate"));
     enddate = Util.null2String(rs.getString("planenddate"));
     content = Util.null2String(rs.getString("plancontent"));
     aim = Util.null2String(rs.getString("planaim"));
     address = Util.null2String(rs.getString("planaddress"));     
     resource = Util.null2String(rs.getString("planresource"));          
     actor = Util.null2String(rs.getString("planactor"));     
     budget = Util.null2String(rs.getString("planbudget"));     
     budgettype = Util.null2String(rs.getString("planbudgettype"));     
     openrange = Util.null2String(rs.getString("openrange"));
     docs=Util.null2String(rs.getString("traindocs"));
     ArrayList arr_docids=Util.TokenizerString(docs,",");
     Iterator iter=arr_docids.iterator();
     StringBuffer sb=new StringBuffer();
     while(iter.hasNext()){
     String docid=(String)iter.next();
     sb.append("<A href='/docs/docs/DocDsp.jsp?id="+docid+"'>"+DocComInfo.getDocname(docid)+"</A>&nbsp") ;
}
docsShowname=sb.toString();
  }  


  // 增加一个培训工作流的获取, 目前默认用培训单据创建的有效工作流为默认培训工作流,如果有多个, 选择第一个
  String applyworkflowid = "" ;
  sql = "select id from workflow_base  where formid = 48 and isbill='1' and isvalid = '1' " ;
  rs.executeSql(sql);
  if( rs.next() ) applyworkflowid = Util.null2String(rs.getString("id")); 
  
  String isclose = Util.null2String(request.getParameter("isclose"));
  String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(89,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6103,user.getLanguage());
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
if(isOperator &&canEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(isOperator){
RCMenu += "{"+SystemEnv.getHtmlLabelName(6104,user.getLanguage())+",/hrm/train/trainplan/HrmTrainPlanRange.jsp?planid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(15781,user.getLanguage())+",javascript:doinfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(canApply && !isend && !applyworkflowid.equals("") ){
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+",/workflow/request/AddRequest.jsp?workflowid="+applyworkflowid+"&TrainPlanId="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmTrain:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+82+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+82+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainplan/HrmTrainPlan.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="dosave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="TrainPlanOperation.jsp" method=post >

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="85%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></TH></TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><%=name%></td>
        </TR>     
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TD>
          <TD class=Field>
            <%=TrainLayoutComInfo.getLayoutname(layoutid)%>	    
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16141,user.getLanguage())%> </td>
          <td class=Field>
	      <%=ResourceComInfo.getMulResourcename(organizer)%>	      
	  </td>	   
        </tr>    
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=Field>
            <%=startdate%>
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>          
          <td class=Field>
            <%=enddate%>            
          </td>            
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
          <td class=Field>
            <%=content%>
          </td>
        </tr>          
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </td>
          <td class=Field>
            <%=aim%>
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1395,user.getLanguage())%></TD>
          <TD class=Field><%=address%>
          </td>
        </TR>                
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></TD>
          <TD class=Field>
            <%=TrainResourceComInfo.getResourcename(resource)%>	    
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(18876,user.getLanguage())%></TD>
          <TD class=Field>
           <span id=docsspan name=docsspan><%=docsShowname%></span>
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
                <tr>
          <td><%=SystemEnv.getHtmlLabelName(15761,user.getLanguage())%> </td>
          <td class=Field>
	      <%=ResourceComInfo.getMulResourcename(actor)%>	      
	  </td>	 
      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
          <TD class=Field>
            <%=budget%>
          </td>
        </TR>        
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15371,user.getLanguage())%></TD>
          <TD class=Field><%=BudgetfeeTypeComInfo.getBudgetfeeTypename(budgettype)%>
          </td>
        </TR>        
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--        <TR>
          <TD>公开范围</TD>
          <TD class=Field><INPUT class=inputstyle type=text size=30 name="openrange" value="<%=openrange%>">
          </td>
        </TR>                 
        </tr>    
-->        
</TBODY>
</TABLE>
 
         <TABLE width="100%"  class=ListStyle cellspacing=1  cols=4 id="oTable">

	      <TBODY> 
          <TR class=Header> 
            <TH colspan=5><%=SystemEnv.getHtmlLabelName(16150,user.getLanguage())%></TH>
		<Td align=right colspan=1>
<!--			 <BUTTON class=btnNew accessKey=A onClick="addoRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
	         <BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteoRow1()};"><U>D</U>-删除</BUTTON> 	
-->	         
 		    </Td>
          </TR>
          <TR class=Spacing style="display:none;height:2px"> 
            <TD class=Line1 colSpan=5></TD>
          </TR>	
		  <tr class=header>
            <td></td>
		    <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>	</td>
            <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%></td>
		  </tr> 
          <TR class=Line><TD colspan="6" ></TD></TR>
  <%int rowindex=0;
    sql = "select * from HrmTrainPlanDay where planid = "+id;  
    rs.executeSql(sql);  
    while(rs.next()){
        String date = Util.null2String(rs.getString("plandate"));
	String daycontent = Util.null2String(rs.getString("plandaycontent"));
	String dayaim = Util.null2String(rs.getString("plandayaim"));
    String starttime = Util.null2String(rs.getString("starttime"));
    String endtime = Util.null2String(rs.getString("endtime"));
%>
	      <tr class=datadark>
            <TD class=Field width=10> 
              
            </td>	        
            <TD class=Field width=100>               
              <%=date%>              
            </TD>
              <TD class=Field width=100>
              <%=starttime%>
            </TD>
              <TD class=Field width=100>
              <%=endtime%>
            </TD>
        <TD class=Field>
              <%=daycontent%>
            </TD>	        	    
	    <TD class=Field> 
              <%=dayaim%>
            </TD>            	       
	      </tr> 
<%
	 rowindex++;	 
	 
  }
%>        
      </tbody>
       </table>

 
 <input class=inputstyle  type="hidden" name=operation>
 <input class=inputstyle  type=hidden name=id value="<%=id%>">
 <input class=inputstyle  type=hidden name=rowindex>
 </form>
   <%if("1".equals(isDialog)){ %>
   </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context="">
				<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
 <script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub

sub onShowLayout()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/trainlayout/TrainLayoutBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	layoutidspan.innerHtml = id(1)
	frmMain.layoutid.value=id(0)
	else
	layoutidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.layoutid.value=""
	end if
	end if
end sub

sub onShowTrainResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	resourcespan.innerHtml = id(1)
	frmMain.resource.value=id(0)
	else
	resourcespan.innerHtml = ""
	frmMain.resource.value=""
	end if
	end if
end sub

</script>
<script language=javascript>
  
rowindex = <%=rowindex%>
function addoRow()
{
	ncol = oTable.cols;
	
	oRow = oTable.insertRow();
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle  type='checkbox' name='check_o' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(datespan_"+rowindex+" , date_"+rowindex+")' > </BUTTON><SPAN id='datespan_"+rowindex+"'></SPAN> <input class=inputstyle  type=hidden id='date_"+rowindex+"' name='date_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;							
			case 2: 
			        var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle  type=text style='width:100%' name='daycontent_"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;                                
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle  type=text style='width:100%' name='dayaim_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		}
	}
	rowindex = rowindex*1 +1;		
}

function deleteoRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_o')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_o'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1+2);	
			}
			rowsum1 -=1;
		}
	
	}	
}	

function dosave(){
  location="HrmTrainPlanEditDo.jsp?id=<%=id%>";
  }
  function dodelete(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
      document.frmMain.operation.value="delete";
      document.frmMain.submit();
    }
  }
function doinfo(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
      document.frmMain.operation.value="info";
      document.frmMain.submit();
    }
  }
 </script>
 
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CapitalDepre" class="weaver.cpt.capital.CapitalDepre" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String checkstockid = Util.toScreen(request.getParameter("checkstockid"),user.getLanguage()) ;					/*创建人id*/
 RecordSet.executeProc("CptCheckStock_SelectByID",checkstockid);
 RecordSet.next();
String checkstockno = Util.toScreenToEdit(RecordSet.getString("checkstockno"),user.getLanguage()) ;			
String checkstockdesc = Util.toScreenToEdit(RecordSet.getString("checkstockdesc"),user.getLanguage()) ;		
String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;					
String location = Util.toScreen(RecordSet.getString("location"),user.getLanguage()) ;					
String checkerid = Util.toScreen(RecordSet.getString("checkerid"),user.getLanguage()) ;					
String approverid = Util.toScreen(RecordSet.getString("approverid"),user.getLanguage()) ;					
String createdate = Util.toScreen(RecordSet.getString("createdate"),user.getLanguage()) ;					
String approvedate = Util.toScreen(RecordSet.getString("approvedate"),user.getLanguage()) ;					
String checkstatus = Util.toScreen(RecordSet.getString("checkstatus"),user.getLanguage()) ;		
boolean canedit=true;
boolean beforeapprove = true;
if(!HrmUserVarify.checkUserRight("CptCapitalCheckStock:Display", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}

if(!HrmUserVarify.checkUserRight("CptCapitalCheckStockEdit:Edit", user)){
    canedit=false;
}

if(checkstatus.equals("1")){
    beforeapprove=false;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1506,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<FORM id=weaver name=frmain action="CapitalCheckStockOperation.jsp" method=post>
 <input type=hidden name=operation>
 <input type=hidden name=checkstockid value="<%=checkstockid%>">

<DIV class=HdrProps></DIV>
<% 
if(beforeapprove){
if(canedit){%>
<BUTTON class=btnSave accessKey=S onclick="onSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%}
if(HrmUserVarify.checkUserRight("CptCapitalCheckStockEdit:Delete", user)){
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}
if(HrmUserVarify.checkUserRight("CptCapitalCheckStock:Approve", user)){
%>
<BUTTON class=Btn id=button2 accessKey=A name=button4 onclick="onApprove()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></BUTTON>
<%}
}//end of checkstatus
if(HrmUserVarify.checkUserRight("CptCapitalCheckStock:Log", user)){
%>
<BUTTON class=BtnLog id=button2 accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=200 and relatedid=<%=checkstockid%>'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<%}
%>

<TABLE class=form>
<COLGROUP> <COL width=50%> <COL width=50%> 
<TBODY>
 <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=20%> <COL width=80%> <TBODY> 
          <TR class=Section> 
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(476,user.getLanguage())%></TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep2 colSpan=2></TD>
          </TR>
          <TR> 
            <!-- -->
            <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
            <TD class=Field> 
            <%if(beforeapprove){%>
           <INPUT class=saveHistory maxLength=25 size=30 name=checkstockno onChange='checkinput("checkstockno","checkstocknoimage")' value="<%=checkstockno%>">
            <%}else{%>
            <%=checkstockno%>
            <%}%>
        <SPAN id=checkstocknoimage></SPAN>
		</TD>
          </TR>
          <TR> 
            <!---->
            <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
            <TD class=Field> 
            <%if(beforeapprove){%>
              <INPUT class=saveHistory maxLength=200 size=30 name=checkstockdesc value="<%=checkstockdesc%>">
            <%}else{%>
            <%=checkstockdesc%>
            <%}%>
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
      </TD>
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=20%> <COL width=80%> <TBODY> 
          <TR class=Section> 
            <TH colSpan=2>&nbsp;</TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep2 colSpan=2></TD>
          </TR>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
            <td class=Field><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%> 
               <input class=saveHistory type=hidden id=departmentid name=departmentid value="<%=departmentid%>">
            </td>
          </tr>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
            <td class=Field id=txtRoom> 
              <%=location%>
            </td>
          </TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(1415,user.getLanguage())%></td>
            <td class=Field> 
              <%=createdate%>
            </td>
          </TR>
		  <TR>
            <td><%=SystemEnv.getHtmlLabelName(1416,user.getLanguage())%></td>
            <td class=Field> 
              <%=Util.toScreen(ResourceComInfo.getResourcename(checkerid),user.getLanguage())%>
               <input class=saveHistory type=hidden id=checkerid name=checkerid value="<%=checkerid%>">
            </td>
          </TR>
          <%if(!beforeapprove){%>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(1425,user.getLanguage())%></td>
            <td class=Field> 
              <%=approvedate%>
            </td>
          </TR>
          <%}%>
          <%if(!beforeapprove){%>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(439,user.getLanguage())%></td>
            <td class=Field> 
              <%=Util.toScreen(ResourceComInfo.getResourcename(approverid),user.getLanguage())%>
            </td>
          </TR>
          <%}%>
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE class=ListShort>
  <COLGROUP>
  <COL width="15%">
  <COL width="15%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="30%">
  <TBODY>
  <TR class=Section>
    <TH colSpan=7><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></TH>
  </TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=7 ></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1417,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1418,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1419,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1420,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
  </TR>
<%
//此变量用于保存提交时所需检查的项
String forcheckstr="";

RecordSet.executeProc("CptCheckStockList_SByCheckSto",""+checkstockid);
    int needchange = 0;
    int count=0;
      while(RecordSet.next()){
        String  id = Util.toScreen(RecordSet.getString("id"),user.getLanguage()) ;
	    String  capitalid = Util.toScreen(RecordSet.getString("capitalid"),user.getLanguage()) ;
        String  theorynumber = Util.toScreen(RecordSet.getString("theorynumber"),user.getLanguage()) ;
        String  realnumber = Util.toScreen(RecordSet.getString("realnumber"),user.getLanguage()) ;
        String  remark = Util.toScreen(RecordSet.getString("remark"),user.getLanguage()) ;
        String  price = Util.toScreen(RecordSet.getString("price"),user.getLanguage()) ;
        int surplusnum=(Util.getIntValue(realnumber)-Util.getIntValue(theorynumber));
       
        double tempprice = (double)(((int)(Util.getFloatValue(price)*100))/100.00);//保留2位小数
        price = ""+tempprice;

        double tempsurplusprice=surplusnum*(Util.getFloatValue(price));

        tempprice = (double)(((int)(tempsurplusprice*100))/100.00);//保留2位小数
        String surplusprice = ""+tempprice;

	 try{
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%}%>
     <TD><a href="../capital/CptCapital.jsp?id=<%=capitalid%>">
      <%=Util.toScreen(CapitalComInfo.getMark(capitalid),user.getLanguage())%></a></TD>
    <TD> <%=Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage())%> </TD>
    <input class=saveHistory type=hidden name=capitalid_<%=count%> value=<%=capitalid%>>
    <TD> <%=theorynumber%> </TD>
	<input class=saveHistory type=hidden name=capitalnum_<%=count%> value=<%=theorynumber%>>
	 <td > <%if(beforeapprove){%>
        <input class=saveHistory 
            maxlength=10 size=7 name="realnum_<%=count%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkinput("realnum_<%=count%>","realnum_<%=count%>image");calcuAll("realnum_<%=count%>","<%=count%>","<%=price%>","realnum_<%=count%>image")' value="<%=realnumber%>">
        <span id="realnum_<%=count%>image"></span> 
        <%}else{%>
        <%=realnumber%>
        <%}%>
      </td>
	  <TD id="surplusnumtd_<%=count%>"><%=surplusnum%></TD>
	 <TD id="surpluspricetd_<%=count%>"><%=surplusprice%></TD>
	<TD> 
       <%if(beforeapprove){%>
       <INPUT class=saveHistory maxLength=200 size=20 name=remark_<%=count%> value="<%=remark%>">
       <%}else{%>
       <%=remark%>
       <%}%>
   </TD>
  </TR>
       <INPUT class=saveHistory type=hidden id=id_<%=count%> name=id_<%=count%> value="<%=id%>">
       <INPUT class=saveHistory type=hidden id=currentprice_<%=count%> name=currentprice_<%=count%> value="<%=price%>">
<%
     forcheckstr += ",realnum_"+count;
     count++;
      }catch(Exception e){
        //System.out.println(e.toString());
      }
    }
%>  
 </TBODY>	
 <input class=saveHistory type=hidden id=count name=count value="<%=count%>">
</TABLE>
 <script language="javascript">
 function onSave(){
 	if(check_form(document.frmain,'checkstockno<%=forcheckstr%>')){
	 	document.frmain.operation.value="edit";
		document.frmain.submit();
	}
 }

 function onApprove(){
	 	document.frmain.operation.value="approve";
		document.frmain.submit();
 }

 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmain.operation.value="delete";
			document.frmain.submit();
		}
}

//计算盈亏数和价值
function calcuAll(objectname,count,tempcapitalprice,spanid)
{	
     //判断input框中是否输入的是数字,包括小数点,代替checknum
	valuechar = document.all(objectname).value.split("") ;
	isnumber = true ;
    tempsurplusnum = 0;
    tempsurplusprice = 0;
	for(i=0 ; i<valuechar.length ; i++) { 
        charnumber = parseInt(valuechar[i]) ; 
        if( isNaN(charnumber)&& valuechar[i]!=".") {
            isnumber = false ;
        }
     }
        
	if(!isnumber){
        //清空
        document.all(objectname).value = "" ;
        document.all(spanid).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
   }
    else if(document.all(objectname).value != ""){
        //计算盈亏数
       tempsurplusnum=document.all("realnum_"+count).value-document.all("capitalnum_"+count).value;
       document.all("surplusnumtd_"+count).innerText=tempsurplusnum;
        //计算盈亏价值
       tempsurplusprice=tempcapitalprice*tempsurplusnum;
       document.all("surpluspricetd_"+count).innerText=tempsurplusprice;
    }
}
 </script>	
	
 </form>
 
</BODY></HTML>

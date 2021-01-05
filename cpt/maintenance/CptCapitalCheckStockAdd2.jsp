<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CapitalDepre" class="weaver.cpt.capital.CapitalDepre" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("CptCapitalCheckStockAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String departmentid = Util.toScreen(request.getParameter("departmentid"),user.getLanguage()) ;					/*创建人id*/
String location = Util.toScreen(request.getParameter("location"),user.getLanguage()) ;					/*创建人id*/
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     			Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String checkerid = ""+user.getUID();
String sql="";
int ishead = 0 ;

if(! departmentid.equals("")) {
	if(ishead == 0) {
		sql += " where departmentid = " + departmentid ;
		ishead = 1;
	}
	else sql += " and departmentid = " + departmentid ;
}

if(! location.equals("")) {
	if(ishead == 0) {
		sql += " where location like '%" + location+"%'" ;
		ishead = 1;
	}
	else sql += " and location like '%" + location+"%'" ;
}


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1506,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<FORM id=weaver name=frmain action="CapitalCheckStockOperation.jsp" method=post>
 <input type=hidden name=operation value="add">

<DIV class=HdrProps></DIV>
<BUTTON class=btnSave accessKey=S onClick="onSubmit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
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
              <INPUT class=saveHistory maxLength=25 size=30 name=checkstockno onChange='checkinput("checkstockno","checkstocknoimage")'>
        <SPAN id=checkstocknoimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		</TD>
          </TR>
          <TR> 
            <!---->
            <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=saveHistory maxLength=200 size=30 name=checkstockdesc>
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
              <input id=departmentid type="hidden" name=departmentid value=<%=departmentid%>>
            </td>
          </tr>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
            <td class=Field id=txtRoom> 
              <%=location%>
			  <input class=saveHistory type=hidden name=location value=<%=location%>>
            </td>
          </TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(1415,user.getLanguage())%></td>
            <td class=Field> 
              <%=currentdate%>
			  <input class=saveHistory type=hidden name=createdate value=<%=currentdate%>>
            </td>
          </TR>
		  <TR>
            <td><%=SystemEnv.getHtmlLabelName(1416,user.getLanguage())%></td>
            <td class=Field> 
              <%=Util.toScreen(ResourceComInfo.getResourcename(checkerid),user.getLanguage())%>
			  <input class=saveHistory type=hidden  name=checkerid value=<%=checkerid%>>
            </td>
          </TR>
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

//盘点单中的资产按照资产编号排序
sql = "select * from CptCapital "+sql+" and stateid='1' order by mark ";
RecordSet.execute(sql);   
    int needchange = 0;
    int count=0;
      while(RecordSet.next()){
	    String  capitalid = Util.toScreen(RecordSet.getString("id"),user.getLanguage()) ;
        String  startprice = RecordSet.getString("startprice");
        String  depreendprice = RecordSet.getString("depreendprice");
        //计算当前资产的当前价值
        float tempcapitalprice = (float)((1-CapitalDepre.getCapitalDepreRatio(capitalid))*(Util.getFloatValue(startprice)));
        tempcapitalprice = (float)(((int)(tempcapitalprice*100))/100.00);//保留2位小数
        if(Util.getFloatValue(depreendprice)>tempcapitalprice){
	        tempcapitalprice = Util.getFloatValue(depreendprice);
        }
        else{
        	tempcapitalprice = tempcapitalprice;
        }
        //end of calculation
		String	mark=Util.toScreen(RecordSet.getString("mark"),user.getLanguage()) ;
		String	capitalnum=Util.toScreen(RecordSet.getString("capitalnum"),user.getLanguage()) ;
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
     <TD><a href="../capital/CptCapital.jsp?id=<%=capitalid%>"><%=mark%></a></TD>
    <TD> <%=Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage())%> </TD>
	<input class=saveHistory type=hidden name=capitalid_<%=count%> value=<%=capitalid%>>
    <TD> <%=capitalnum%> </TD>
	<input class=saveHistory type=hidden name=capitalnum_<%=count%> value=<%=capitalnum%>>
	 <td > 
        <input class=saveHistory 
            maxlength=10 size=7 name="realnum_<%=count%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkinput("realnum_<%=count%>","realnum_<%=count%>image");calcuAll("realnum_<%=count%>","<%=count%>","<%=tempcapitalprice%>","realnum_<%=count%>image")' value="<%=capitalnum%>">
        <span id="realnum_<%=count%>image"></span> 
      </td>
	  <TD id="surplusnumtd_<%=count%>">0</TD>
	 <TD id="surpluspricetd_<%=count%>">0</TD>
	<TD> 
       <INPUT class=saveHistory maxLength=200 size=20 name=remark_<%=count%>>
    </TD>
  </TR>
	<input class=saveHistory type=hidden id=currentprice_<%=count%> name=currentprice_<%=count%> value="<%=tempcapitalprice%>">
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
 function onSubmit(){
 	if(check_form(document.frmain,'checkstockno<%=forcheckstr%>')){
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

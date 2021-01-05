<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*,weaver.datacenter.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="StatitemComInfo" class="weaver.datacenter.StatitemComInfo" scope="page" />


<%
String outrepid = Util.null2String(request.getParameter("outrepid"));
String outrepcategory = Util.null2String(request.getParameter("outrepcategory"));
String isself = Util.null2String(request.getParameter("isself"));
boolean initright = false ;

String chartstr = "" ;              // 图片基本属性的字符串
String chartvaluestr = "" ;         // 图片值的字符串


OutReportPic OutReportPic = (OutReportPic)session.getAttribute("weaverOutReportPic") ;
if(OutReportPic == null || !outrepcategory.equals(OutReportPic.getOutRepCategory())) {
    if( outrepcategory.equals("1") ) OutReportPic = new OutReportStatPic() ; // 明细报表
    else if( outrepcategory.equals("2") ) OutReportPic = new OutReportOrderPic() ; // 排序报表
    session.setAttribute("weaverOutReportPic", OutReportPic)  ;
}


if(!outrepid.equals(OutReportPic.getOutRepID())) {
    OutReportPic.init(outrepid, user) ;
}

String outrepname = OutReportPic.getOutRepName() ;
ArrayList allstatitems = OutReportPic.getAllstatitems() ;
ArrayList allstatitemnames = null ;
if(outrepcategory.equals("2"))  allstatitemnames = OutReportPic.getAllstatitemNames() ;

ArrayList modulenames = OutReportPic.getModulenames() ;
ArrayList conditionvalues = OutReportPic.getConditionvalues() ;
// 对其它条件进行设置
ArrayList  conditionids = null ;
ArrayList  issystemdefs = null ;
ArrayList  conditionnames = null ;
ArrayList  fieldnames = null ;
ArrayList  conditiontypes = null ;

if(outrepcategory.equals("2")) {
    conditionids = OutReportPic.getConditionids() ;
    issystemdefs = OutReportPic.getIssystemdefs() ;
    conditionnames = OutReportPic.getConditionnames() ;
    fieldnames = OutReportPic.getFieldnames() ;
    conditiontypes = OutReportPic.getConditiontypes() ;
}


String crm = "" ;
String crm1 = "" ;
String datefrom = "" ;
String dateto = "" ;
String issumtotal = "" ;
String abscissavalue = "" ;
String dataunit = "";

int reportrowindex = 0 ;             // 行数（作为 Series 的数量）
int outrepcolumn = 0 ;            // 列数（作为 横坐标 的数量）
int statitemcount = 0 ;               // 统计项目个数 （作为图表的个数 ）
int picwidth = 0 ;           // 插件图片的宽度
int pichight = 0 ;                            // 插件图片的宽度
double picChart3DPercent = 0 ;                // 柱状图Z 轴的延迟比例

ArrayList statitems = new ArrayList() ;
ArrayList crmids = null ;
ArrayList reportdates = null ;


if(isself.equals("1")) {
    OutReportPic.initRequest(request, user) ;
    OutReportPic.initReportValue() ;

    crm = OutReportPic.getCrm() ;
    crm1 = OutReportPic.getCrm1() ;
    datefrom = OutReportPic.getDatefrom() ;
    dateto = OutReportPic.getDateto() ;
    issumtotal = OutReportPic.getIssumtotal() ;
    abscissavalue = OutReportPic.getAbscissavalue() ;
    if(outrepcategory.equals("2")) dataunit = OutReportPic.getDataUnit() ;      // 时间周期

    reportrowindex = OutReportPic.getReportRowCount() ;             // 行数（作为 Series 的数量）
    outrepcolumn = OutReportPic.getReportColumnCount() ;            // 列数（作为 横坐标 的数量）
    statitemcount = OutReportPic.getStatitemcount() ;               // 统计项目个数 （作为图表的个数 ）
    if(abscissavalue.equals("1")) picwidth = 400 + outrepcolumn * 60 ;  // 插件图片的宽度 (日期为坐标)
    else picwidth = 400 + outrepcolumn * 150 ;                           // 插件图片的宽度 (客户为坐标)
    pichight = 200 + reportrowindex*40 ;                            // 插件图片的高度
    picChart3DPercent = (pichight*100.00)/ (picwidth*1.00) ;

    statitems = OutReportPic.getStatitems() ;
    crmids = OutReportPic.getCrmids() ;
    reportdates = OutReportPic.getReportdates() ;
}

String imagefilename = "/images/hdCRMAccount.gif";
String titlename = SystemEnv.getHtmlLabelName(16901,user.getLanguage()) + ": " + outrepname ;
String needfav ="1";
String needhelp ="";

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<BODY onload="ChartBaseSet()">
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16629,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
// RCMenu += "{Excel,/weaver/weaver.file.ExcelOut?excelfile=ExcelFile1,_self} " ;
// RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/datacenter/report/OutReportSel.jsp?outrepid="+outrepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
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


<FORM id=frmMain name= frmMain action="OutReportStat.jsp" method=post>
<input type="hidden" name="outrepid" value="<%=outrepid%>">
<input type="hidden" name="outrepcategory" value="<%=outrepcategory%>">
<input type="hidden" name="isself" value="1">

  <table class=ViewForm>
    <colgroup>
    <col width = "15%">
    <col width = "35%">
    <col width = "15%">
    <col width = "35%">
    <tbody>
    <tr class = Title>
      <TH colSpan = 4><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TH>
    </TR>
    <tr>
        <TD><%=SystemEnv.getHtmlLabelName(16893,user.getLanguage())%></TD>
        <TD class=Field colSpan = 3>
        <%
            for( int i=0 ; i<allstatitems.size() ; i++ ) {
                String statitemid = (String)allstatitems.get(i)  ;
                String statitemname = "" ;
                if(outrepcategory.equals("1")) {
                    if(user.getLanguage()==8) statitemname=StatitemComInfo.getStatitemenname(statitemid) ;
                    if(user.getLanguage()==7||user.getLanguage()==9 || statitemname.equals(""))  statitemname=StatitemComInfo.getStatitemname(statitemid) ;
                }
                else statitemname = (String)allstatitemnames.get(i)  ;
                String checkedstr = "" ;
                if( statitems.indexOf(statitemid) != -1 ) checkedstr = "checked" ;
        %>
            <input type="checkbox" name="sqlselectitem" value="<%=statitemid%>" <%=checkedstr%>><%=statitemname%>&nbsp;
        <%
            }
        %>
        </TD>
    </tr>
    <TR class=spacing><TD class=line colSpan=2 ></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(16902,user.getLanguage())%></TD>
      <td class=Field >
          <select class="InputStyle" name='crm' onChange = "showType()"> 
          <% 
            for ( int i=0 ; i<modulenames.size() ; i++ ) {
                String modulename = (String) modulenames.get(i) ;
                String conditionvalue = (String) conditionvalues.get(i) ;
                String selectstr = "" ;
                if(conditionvalue.equals(crm)) selectstr = "selected" ;
          %>
          <option value='<%=conditionvalue%>' <%=selectstr%>><%=modulename%></option>
          <% } %>
          <option value='-1' <% if(!crm1.equals("")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
          </select>
          
          <div id="crm1div" <% if(crm1.equals("")) {%>style = "display:none"<%}%>>
          <button class=Browser onClick="onShowCustomer('crm1span','crm1')"></button>
          <SPAN id=crm1span>
          <% if(crm1.equals("")) {%><IMG src="/images/BacoError.gif" align=absMiddle>
          <% } else {
                  String crms[] = Util.TokenizerString2(crm1,",") ;
                  String crmname = "" ;
                  for(int i=0 ; i< crms.length ; i++) {
                       if(i==0) crmname +=  Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crms[i]),user.getLanguage()) ;
                       else
                       crmname += ","+ Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crms[i]),user.getLanguage()) ;
                  }
          %><%=crmname%>
          <%}%>
          </SPAN>
        </div>
        <input type="hidden" id="crm1" name="crm1" value=<%=crm1%>>
       </TD>
       <TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
       <TD class=Field> 
        <%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><BUTTON class=Calendar onclick="getDate(datefromspan,datefrom)"></BUTTON> <SPAN id=datefromspan style="FONT-SIZE: x-small">
        <% if(datefrom.equals("")) {%>
        <IMG src="/images/BacoError.gif" align=absMiddle>
        <% } else {%><%=datefrom%><%}%>
        </SPAN>-
		<%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%><BUTTON class=Calendar onclick="getDate(datetospan,dateto)"></BUTTON> <SPAN id=datetospan style="FONT-SIZE: x-small"><% if(dateto.equals("")) {%>
        <IMG src="/images/BacoError.gif" align=absMiddle>
        <% } else {%><%=dateto%><%}%></SPAN> 
        <input type="hidden" name="datefrom" id="datefrom" value="<%=datefrom%>"> 
		<input type="hidden" name="dateto" id="dateto" value="<%=dateto%>"> 
        <% if(outrepcategory.equals("2")) { %>
        <%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%>
        <select class="InputStyle" name='dataunit' >
            <option value='1' <% if(dataunit.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16889,user.getLanguage())%></option>
            <option value='2' <% if(dataunit.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></option>
            <option value='3' <% if(dataunit.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option>
            <option value='4' <% if(dataunit.equals("4")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%></option>
            <option value='5' <% if(dataunit.equals("5")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option>
        </select>
        <% } %>
       </TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(16903,user.getLanguage())%></TD>
      <td class=Field id=txtLocation> 
        <select class="InputStyle" name='abscissavalue' style='width:50%'>
            <option value='1' <% if(abscissavalue.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></option>
            <option value='2' <% if(abscissavalue.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16902,user.getLanguage())%></option>
        </select>
      </TD>
      <TD><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></TD>
      <TD class=Field> 
        <input type="checkbox" name="issumtotal" value="1" <%if(issumtotal.equals("1")) {%> checked <%}%>>
      </TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <% if(outrepcategory.equals("2")) { %>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></TD>
      <TD class=Field> 
        <!--  其它条件设置 -->
        <TABLE class=viewform>
            <COLGROUP>
            <COL width="30%">
            <COL width="70%">
            <TBODY>
        <%  
            for(int k=0 ; k< conditionids.size() ; k++ ) {
                String tempconditionid = (String)conditionids.get(k) ;
                String issystemdef = (String)issystemdefs.get(k) ;
                String conditionname = (String)conditionnames.get(k) ;
                String tempfieldname = (String)fieldnames.get(k) ;
                String tempconditiontype = (String)conditiontypes.get(k) ;
         
                if(!issystemdef.equals("1")) {
          %>
            <TR>
              <TD><%=conditionname%></TD>
              <TD>
              <%    if(tempconditiontype.equals("1")) { %>
              <INPUT type=text class="InputStyle" size=50 name="<%=tempfieldname%>">
              <%    } else { %>
              <select class="InputStyle" name="<%=tempfieldname%>" style="width:30%">
              <% 
                        RecordSet.executeProc("T_CDetail_SelectByConditionid",tempconditionid);
                        while(RecordSet.next()) {
                            String conditiondsp = Util.null2String(RecordSet.getString("conditiondsp")) ;
                            String conditionendsp = Util.null2String(RecordSet.getString("conditionendsp")) ;
                            if(user.getLanguage() == 8 && !conditionendsp.equals("")) conditiondsp = conditionendsp ;
                            String conditionvalue = Util.null2String(RecordSet.getString("conditionvalue")) ;
              %>
              <option value="<%=conditionvalue%>"><%=conditiondsp%></option>
              <%        } %>
              </select>
              <%    } %>
              </td>
            </tr><TR><TD class=Line colSpan=2></TD></TR> 
           <%   } else {              // issystemdef = 1 
                    if(tempfieldname.indexOf("crm") == 0 || tempfieldname.equals("yearf") || tempfieldname.equals("monthf") || tempfieldname.equals("dayf") || tempfieldname.equals("yeart") || tempfieldname.equals("montht") || tempfieldname.equals("dayt") ) continue ;
                    else if(tempfieldname.equals("modify")) { %>
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(17030,user.getLanguage())%></TD>
              <td> 
               <input type="checkbox" id="modify" name="modify" value=1>
              </TD>
            </TR><TR><TD class=Line colSpan=2></TD></TR> 
            <%      }
                    else if(tempfieldname.equals("monthmodify")) { %>
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(17031,user.getLanguage())%></TD>
              <td> 
               <input type="checkbox" id="monthmodify" name="monthmodify" value=1>
              </TD>
            </TR><TR><TD class=Line colSpan=2></TD></TR> 
            <%      }
                    else if(tempfieldname.equals("yearmodify")) { %>
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(17032,user.getLanguage())%></TD>
              <td> 
               <input type="checkbox" id="yearmodify" name="yearmodify" value=1>
              </TD>
            </TR><TR><TD class=Line colSpan=2></TD></TR> 
            <%      }
                }
            }
            %>
          </TBODY>
         </TABLE>
      </TD>
      <TD></TD>
      <td></TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR>
    <% } %>
    </TBODY> 
  </TABLE>
</FORM>
<br>

<% 
if(isself.equals("1")) { 

    ArrayList columnvalues = null ;   // 横向的值
    ArrayList rowvalues = null ;   // 纵向的值
    boolean isreportcolumn = false ;   // 是否以日期作为横坐标

    if( abscissavalue.equals("1")) {
        isreportcolumn = true ;
        columnvalues = reportdates ;
        if( issumtotal.equals("1")) {
            rowvalues = new ArrayList() ;
            rowvalues.add("All") ;
        }
        else rowvalues = crmids ;
    }
    else {
        columnvalues = crmids ;
        if( issumtotal.equals("1")) {
            rowvalues = new ArrayList() ;
            rowvalues.add("All") ;
        }
        else rowvalues = reportdates ;
    }
    
    for ( int i=0 ; i < statitemcount ; i++ ) {
        String statitemid = (String)statitems.get(i)  ;
        String statitemname = "" ;
        if(outrepcategory.equals("1")) {
            if(user.getLanguage()==8) statitemname=StatitemComInfo.getStatitemenname(statitemid) ;
            if(user.getLanguage()==7||user.getLanguage()==9 || statitemname.equals(""))  statitemname=StatitemComInfo.getStatitemname(statitemid) ;
        }
        else {
            int statitemindex = allstatitems.indexOf(statitemid) ;
            if(statitemindex != -1) statitemname = (String)allstatitemnames.get(statitemindex)  ;
        }

        chartstr += "set Tc = TeeCommander" + i + " \n" ;
        chartstr += "set Cc = Chart" + i + " \n" ;
        chartstr += "Tc.Chart=Cc " + " \n" ;
        chartstr += "Cc.Environment.IEPrintWithPage=True " + " \n" ;
        chartstr += "Cc.ClipPoints=False " + " \n" ;
        chartstr += "Cc.Aspect.OpenGL.LightPosition.X = 1000 " + " \n" ;        // Sets the X,Y,Z location of the light source.

        chartstr += "Cc.Aspect.OpenGL.LightPosition.Y = 450 " + " \n" ;
        chartstr += "Cc.Aspect.OpenGL.LightPosition.Z = -700 " + " \n" ;
        chartstr += "Cc.Aspect.Zoom=100 " + " \n" ;
        chartstr += "Cc.Aspect.Orthogonal=true" + " \n" ;
        chartstr += "Cc.Aspect.Perspective=55" + " \n" ;
        chartstr += "Cc.TimerEnabled=false" + " \n" ;
        chartstr += "\n\n" ;

        chartvaluestr += "set Cc = Chart" + i + " \n" ;
        chartvaluestr += "Cc.RemoveAllSeries" + " \n" ; 
        chartvaluestr += "Cc.Header.Text.Clear" + " \n" ;                       // 顶部文字
        chartvaluestr += "Cc.Header.Text.Add(\""+outrepname+"\")" + " \n" ;
        chartvaluestr += "Cc.Header.Font.Size=14" + " \n" ;
        chartvaluestr += "Cc.Header.Font.Color=RGB(0,0,0)" + " \n" ;
        chartvaluestr += "Cc.Header.Font.Bold=True" + " \n" ;
        chartvaluestr += "Cc.Footer.Text.Clear" + " \n" ;                       // 底部文字
        chartvaluestr += "Cc.Footer.Text.Add(\""+statitemname+"\")" + " \n" ;
        chartvaluestr += "Cc.Footer.Visible=True" + " \n" ;
        chartvaluestr += "Cc.Footer.Font.Size=14" + " \n" ;
        chartvaluestr += "Cc.Footer.Font.Color=RGB(0,0,0)" + " \n" ;
        chartvaluestr += "Cc.Footer.Font.Bold=True" + " \n" ;
        chartvaluestr += "Cc.Legend.Alignment=1" + " \n" ;                      // 图示
        chartvaluestr += "Cc.Legend.ColorWidth=8" + " \n" ;
        chartvaluestr += "Cc.Panel.Gradient.Visible=True" + " \n" ;             // 平面剃度
        chartvaluestr += "Cc.Panel.Gradient.Direction=6" + " \n" ;              
        chartvaluestr += "Cc.Panel.Color=Cc.Panel.Gradient.EndColor" + " \n" ;  // 平面其它属性
        chartvaluestr += "Cc.Panel.BevelOffset=0" + " \n" ;
        chartvaluestr += "Cc.Aspect.Chart3DPercent=" + picChart3DPercent + " \n" ;                // Z 坐标延伸百分比
        chartvaluestr += "Cc.Walls.Left.Pen.Color=RGB(0,0,255)" + " \n" ;       // 墙面属性
        chartvaluestr += "Cc.Walls.Left.Color=RGB(235,200,225)" + " \n" ;
        chartvaluestr += "Cc.Walls.Left.Dark3D=False" + " \n" ;
        chartvaluestr += "Cc.Walls.Left.Size=8" + " \n" ;
        chartvaluestr += "Cc.Walls.Bottom.Size=8" + " \n" ;
        chartvaluestr += "Cc.Walls.Back.Color=RGB(180,150,200)" + " \n" ;
        chartvaluestr += "Cc.Walls.Back.Size=8" + " \n" ;
        chartvaluestr += "Cc.Walls.Back.Transparent=False" + " \n" ;
        chartvaluestr += "Cc.Axis.Left.Title.Caption=\""+SystemEnv.getHtmlLabelName(16711,user.getLanguage())+"\"" + " \n" ;
        chartvaluestr += "Cc.Axis.Left.Labels.Font.Bold=true" + " \n" ;
        chartvaluestr += "Cc.Axis.Left.Labels.Font.Size=8" + " \n" ;
        chartvaluestr += "Cc.Axis.Left.GridPen.Color=RGB(245,235,225)" + " \n" ;
        chartvaluestr += "Cc.Walls.Back.Color=RGB(180,150,200)" + " \n" ;
        chartvaluestr += "Cc.Axis.Left.GridPen.Style=0" + " \n" ;
        chartvaluestr += "Cc.Axis.Depth.Visible=true" + " \n" ;
        chartvaluestr += "Cc.Axis.Bottom.Labels.Style=talText" + " \n" ;
        chartvaluestr += "Cc.Axis.Bottom.Labels.Font.Size=8" + " \n" ;
        chartvaluestr += "Cc.Axis.Bottom.Ticks.Width=3" + " \n" ;
        chartvaluestr += "Cc.Axis.Bottom.Ticks.Color=RGB(200,150,200)" + " \n" ;
        
        chartvaluestr += "\n\n" ;

%>

<TABLE class=liststyle cellspacing=1 >
  <TBODY>
  <TR class=header>
    <TH colSpan=<%=outrepcolumn%>><%=statitemname%></TH></TR>
    <!-- 头部信息 -->
    <TR class=Header>
    <TD>&nbsp;</TD>
<% 
        for( int j=0 ; j< columnvalues.size() ; j++ ) {
            String columnvalue = (String) columnvalues.get(j) ;
            String columnvaluestr = columnvalue ;
            if(!isreportcolumn) {
                if(user.getLanguage()==7||user.getLanguage()==9) columnvaluestr = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(columnvalue),user.getLanguage()) ;
                else columnvaluestr = Util.toScreen(CustomerInfoComInfo.getCustomerInfoEngname(columnvalue),user.getLanguage()) ;
            }
%>
    <TD><%=columnvaluestr%></TD>
<%
        }
%>
    </TR>  
    <TR class=line ><TD colSpan=<%=outrepcolumn%>></TD></TR>
    <!-- 头部信息 -->
    
    <!-- 中间信息 -->
<% 
        for( int k=0 ; k< rowvalues.size() ; k++ ) {
            String rowvalue = (String) rowvalues.get(k) ;
            String rowvaluelabel = rowvalue ; 
            if( rowvalue.equals("All") ) rowvaluelabel = SystemEnv.getHtmlLabelName(358,user.getLanguage()) ;
            else if( isreportcolumn ) {
                if(user.getLanguage()==7||user.getLanguage()==9) rowvaluelabel = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(rowvalue),user.getLanguage()) ;
                else rowvaluelabel = Util.toScreen(CustomerInfoComInfo.getCustomerInfoEngname(rowvalue),user.getLanguage()) ;
            }
                
            chartvaluestr += "Cc.AddSeries( 1 )" + " \n" ;
            chartvaluestr += "set Sc = Cc.Series("+k+")" + " \n" ;
            chartvaluestr += "ScColor = Sc.Color" + " \n" ;
            chartvaluestr += "Sc.Clear" + " \n" ;
            chartvaluestr += "Sc.Title=\""+rowvaluelabel+"\"" + " \n" ;
            chartvaluestr += "Sc.asBar.AutoMarkPosition=True" + " \n" ;
            chartvaluestr += "Sc.Marks.Style = smsValue" + " \n" ;
//            chartvaluestr += "Sc.Cursor = 2020" + " \n" ;
            chartvaluestr += "Sc.Marks.Frame.Color= RGB(240,150,240)" + " \n" ;
            chartvaluestr += "Sc.AsBar.BarWidth=30" + " \n" ;
            chartvaluestr += "Sc.AsBar.BarStyle=3" + " \n" ;
            chartvaluestr += "Sc.AsBar.MultiBar=0" + " \n" ;

%>
  <TR class=datalight>
    <TD><%=rowvaluelabel%></TD>
<%  
            for( int j=0 ; j< columnvalues.size() ; j++ ) {
                String columnvalue = (String) columnvalues.get(j) ;
                String columnvaluestr = columnvalue ;
                if(!isreportcolumn) {
                    if(user.getLanguage()==7||user.getLanguage()==9) columnvaluestr = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(columnvalue),user.getLanguage()) ;
                    else columnvaluestr = Util.toScreen(CustomerInfoComInfo.getCustomerInfoEngname(columnvalue),user.getLanguage()) ;
                }

                double thevalue = 0 ;
                String thevaluestr = "" ;
                if(!isreportcolumn) thevalue = OutReportPic.getReportValue(columnvalue,rowvalue, i) ;
                else thevalue = OutReportPic.getReportValue(rowvalue,columnvalue, i) ;

                if(thevalue != 0) thevaluestr = "" + (new BigDecimal(thevalue)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
                
                chartvaluestr += "Sc.Add " + thevalue + ", \""+columnvaluestr+ "\", ScColor" + " \n" ;
%>
    <TD align=right><%=thevaluestr%></TD>
<%          }
%>
  </TR>
<%      }
%>  
</TBODY></TABLE>
<br>
<table border="0" width="100%">
  <tr>
    <td width="100%">
            <OBJECT align=textTop 
            classid=CLSID:BEE97215-8536-11D2-808C-006097385FF5 
            data=data:application/x-oleobject;base64,FXLpvjaF0hGAjABglzhf9VRQRjANVFRlZUNvbW1hbmRlcgAETGVmdAIAA1RvcAIABVdpZHRoA2cCBkhlaWdodAIgAAA= 
            height=32 id=TeeCommander<%=i%> name=TeeCommander<%=i%>  width="<%=picwidth%>" codebase="/weaverplugin/teechart.ocx#version=3,0,0,0"></OBJECT>
    </td>
  </tr>
  <tr>
    <td width="100%">
            <OBJECT classid=CLSID:008BBE7E-C096-11D0-B4E3-00A0C901D681 
            data=data:application/x-oleobject;base64,fr6LAJbA0BG04wCgyQHWgVRQRjAKVE9EQkNDaGFydAAETGVmdAIAA1RvcAIABVdpZHRoA2MCBkhlaWdodAMMARRCYWNrV2FsbC5CcnVzaC5Db2xvcgcHY2xXaGl0ZRRCYWNrV2FsbC5CcnVzaC5TdHlsZQcHYnNDbGVhchJUaXRsZS5UZXh0LlN0cmluZ3MBBghUZWVDaGFydAAAAAAAAAABAAAAAA== 
            height="<%=pichight%>" id="Chart<%=i%>" name="Chart<%=i%>" type=application/x-oleobject 
            width="<%=picwidth%>" codebase="/weaverplugin/teechart.ocx#version=3,0,0,0"></OBJECT>
    </td>
  </tr>
</table>
<br>
<%  }
}
%>


</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


<script language=vbs>
sub getDate(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if returndate <> "" then
		inputname.value= returndate
		spanname.innerHtml = returndate
	else 
		inputname.value= ""
		spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	end if
end sub

sub onShowCustomer(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp")
	if NOT isempty(id) then
        if id(0)<> "" then
		document.all(tdname).innerHtml = right(id(1),len(id(1))-1)
		document.all(inputename).value = right(id(0),len(id(0))-1)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value =""
		end if
	end if
end sub


Sub ChartBaseSet

<%=chartstr%>

FillChart()

End sub


SUB FillChart

<%=chartvaluestr%>

END SUB


</script>



<script language="javascript">
function submitData()
{
	if (check_form(document.frmMain,'crm,datefrom,dateto'))
		document.frmMain.submit();
}

function showType(){
    itemtypelist = window.document.frmMain.crm ;
    if(itemtypelist.value==-1){
        crm1div.style.display='';
    }
    else {
        document.frmMain.crm1.value = '' ;
        crm1div.style.display='none';
    }
}
</script>
</BODY>
</HTML>

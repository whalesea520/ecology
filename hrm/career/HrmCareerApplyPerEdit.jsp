
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<html>
<%!
    /**
     * Add by Charoes ,remove the zero behind a Two Digit precision Decimal .
     * @param s
     * @return
     */
    private String trimZero(String s){
        int index = s.indexOf(".");
        if(index !=-1){
            String temp = s.substring(index+1);
            if(temp.equals("00"))
                s = s.substring(0,index);
            else{
                if(temp.substring(temp.length()-1).equals("0") ){
                    s = s.substring(0,s.length()-1)      ;
                }
            }
        }
        return s;
    }

%>
<%
String id = request.getParameter("id"); 
String isView = request.getParameter("isView");
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:edit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/career/HrmCareerApplyPerView.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM name=resourcepersonalinfo id=resource action="HrmCareerApplyOperation.jsp" method=post >
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=isView value="<%=isView%>">
 <TABLE class=ViewForm>

	<TBODY> 
    <TR> 
      <TD vAlign=top>
      <TABLE width="100%">
          <COLGROUP> 
          <COL width=20%> 
          <COL width=80%>
	      <TBODY> 
          <TR class=Title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%></TH>
          </TR>
         
 <%
  String sql = "";
  sql = "select * from HrmCareerApply where id = "+id;  
  rs.executeSql(sql);
  while(rs.next()){
    String birthday = Util.null2String(rs.getString("birthday"));
    String folk = Util.null2String(rs.getString("folk"));
    String nativeplace = Util.null2String(rs.getString("nativeplace"));
    String regresidentplace = Util.null2String(rs.getString("regresidentplace"));
    String certificatenum = Util.null2String(rs.getString("certificatenum"));    
    String maritalstatus = Util.null2String(rs.getString("maritalstatus"));
    String policy = Util.null2String(rs.getString("policy"));
    String bememberdate = Util.null2String(rs.getString("bememberdate"));
    String bepartydate = Util.null2String(rs.getString("bepartydate"));
    String islabouunion = Util.null2String(rs.getString("islabouunion"));
    String educationlevel = Util.null2String(rs.getString("educationlevel"));
    String degree = Util.null2String(rs.getString("degree"));
    String healthinfo = Util.null2String(rs.getString("healthinfo"));
    String height = Util.null2String(rs.getString("height"));

    String weight = Util.null2String(rs.getString("weight"));
    String residentplace = Util.null2String(rs.getString("residentplace"));
    String homeaddress = Util.null2String(rs.getString("homeaddress"));
    String tempresidentnumber = Util.null2String(rs.getString("tempresidentnumber"));    
%>        
	 <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></TD>
            <TD class=Field>
              <BUTTON class=Calendar id=selectbirthday onclick="getbirthdayDate()"></BUTTON> 
              <SPAN id=birthdayspan ><%=birthday%>
              </SPAN> 
              <input class=inputstyle type="hidden" name="birthday" value="<%=birthday%>">                            
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle type=text name=folk value="<%=folk%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle type=text name=nativeplace value="<%=nativeplace%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle type=text name=regresidentplace value="<%=regresidentplace%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle type=text name=certificatenum value="<%=certificatenum%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TD>
            <TD class=Field> 
              <select name=maritalstatus value="<%=maritalstatus%>">
                <option value="0" <%if(maritalstatus.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%> </option>
                <option value="1" <%if(maritalstatus.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%> </option>
                <option value="2" <%if(maritalstatus.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%> </option>
              </select>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle type=text name=policy value="<%=policy%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></TD>
            <TD class=Field>
              <button class=Calendar id=selectbememberdate onClick="getbememberdateDate()"></button> 
              <span id=bememberdatespan ><%=bememberdate%></span> 
              <input class=inputstyle type="hidden" name="bememberdate" value="<%=bememberdate%>">               
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></TD>
            <TD class=Field>
              <button class=Calendar id=selectbepartydate onClick="getbepartydateDate()"></button> 
              <span id=bepartydatespan ><%=bepartydate%></span> 
              <input class=inputstyle type="hidden" name="bepartydate" value="<%=bepartydate%>">               
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></TD>
            <TD class=Field>
              <select class=inputstyle id=islabouunion name=islabouunion value="<%=islabouunion%>">
                <option value=1 <%if(islabouunion.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
                <option value=0 <%if(islabouunion.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>                
              </select>               
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></TD>
            <TD class=Field>
              <BUTTON class=Browser name="btneducationlevel"  onclick="onShowEduLevel(educationlevelspan,educationlevel)"> </BUTTON>
              <SPAN id=educationlevelspan><%=EduLevelComInfo.getEducationLevelname(educationlevel)%></SPAN>
              <input class=inputstyle type=hidden name=educationlevel value="<%=educationlevel%>">               
            </TD>
          </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle type=text name=degree value="<%=degree%>">
            </TD>
          </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></TD>
            <TD class=Field>
              <select class=inputstyle id=healthinfo name=healthinfo value="<%=healthinfo%>">
                <option value=0 <%if(healthinfo.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%></option>
                <option value=1 <%if(healthinfo.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option>
                <option value=2 <%if(healthinfo.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
                <option value=3 <%if(healthinfo.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%></option>
              </select>               
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle maxlength=5  size=5 name=height value="<%=trimZero(height)%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("height")'>
              cm
            </TD>
          </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
       	  <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle maxlength=5  size=5 name=weight value="<%=trimZero(weight)%>"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("weight")'>
              kg
            </TD>
          </TR>
      <TR><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle type=text name=residentplace value="<%=residentplace%>">
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--	      <TR> 
            <TD >家庭联系方式</TD>
            <TD class=Field> 
              <input class=inputstyle type=text name=homeaddress value="<%=homeaddress%>">
            </TD>
          </TR>
-->          
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle type=text name=tempresidentnumber value="<%=tempresidentnumber%>">
            </TD>
          </TR>
      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<%
  }
%>        

<%--begin 自定义字段--%>

<%
    int scopeId = 1;
	String needinputitems = "";
    CustomFieldManager cfm = new CustomFieldManager("CareerCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    cfm.getCustomData(Util.getIntValue(id,0));
    while(cfm.next()){
        if(cfm.isMand()){
            needinputitems += ",customfield"+cfm.getId();
        }
        String fieldvalue = cfm.getData("field"+cfm.getId());
%>
    <tr>
      <td <%if(cfm.getHtmlType().equals("2")){%> valign=top <%}%>> <%=cfm.getLable()%> </td>
      <td class=field >
      <%
        if(cfm.getHtmlType().equals("1")){
            if(cfm.getType()==1){
                if(cfm.isMand()){
      %>
        <input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=50 onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
        <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%
                }else{
      %>
        <input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" value="" size=50>
      <%
                }
            }else if(cfm.getType()==2){
                if(cfm.isMand()){
      %>
        <input  datatype="int" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
            onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
        <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%
                }else{
      %>
      <input  datatype="int" type=text  value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
      <%
                }
            }else if(cfm.getType()==3){
                if(cfm.isMand()){
      %>
        <input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
		    onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
        <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%
                }else{
      %>
        <input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
      <%
                }
            }
        }else if(cfm.getHtmlType().equals("2")){
            if(cfm.isMand()){

      %>
        <textarea class=Inputstyle name="customfield<%=cfm.getId()%>" onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')"
		    rows="4" cols="40" style="width:80%" class=Inputstyle><%=fieldvalue%></textarea>
        <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%
            }else{
      %>
        <textarea class=Inputstyle name="customfield<%=cfm.getId()%>" rows="4" cols="40" style="width:80%"><%=fieldvalue%></textarea>
      <%
            }
        }else if(cfm.getHtmlType().equals("3")){

            String fieldtype = String.valueOf(cfm.getType());
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值

            String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
            String newdocid = Util.null2String(request.getParameter("docid"));

            if( fieldtype.equals("37") && !newdocid.equals("")) {
                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                fieldvalue += newdocid ;
            }

            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")) {
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                sql = "";

                HashMap temRes = new HashMap();

                if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }

                RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    showid = Util.null2String(RecordSet.getString(1)) ;
                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                        temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                    else{
                        //showname += tempshowname ;
                        temRes.put(String.valueOf(showid),tempshowname);
                    }
                }
                StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                String temstkvalue = "";
                while(temstk.hasMoreTokens()){
                    temstkvalue = temstk.nextToken();

                    if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                        showname += temRes.get(temstkvalue);
                    }
                }

            }



	   %>
        <button class=Browser type="button" onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=cfm.isMand()?"1":"0"%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="customfield<%=cfm.getId()%>" value="<%=fieldvalue%>">
        <span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%>
            <%if(cfm.isMand() && fieldvalue.equals("")) {%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%>
        </span>
       <%
        }else if(cfm.getHtmlType().equals("4")){
       %>
        <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> >
       <%
        }else if(cfm.getHtmlType().equals("5")){
            cfm.getSelectItem(cfm.getId());
       %>
       <select class=InputStyle name="customfield<%=cfm.getId()%>" class=InputStyle>
       <%
            while(cfm.nextSelect()){
       %>
            <option value="<%=cfm.getSelectValue()%>" <%=cfm.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm.getSelectName()%>
       <%
            }
       %>
       </select>
       <%
        }
       %>
            </td>
        </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD>
  </TR>
       <%
    }
       %>
<input class=inputstyle type=hidden name=scopeid value="<%=scopeId%>">

<%--end 自定义字段--%>
 	      </tbody>
       </table>
   </tr>

 
<%
  sql = "select * from HrmFamilyInfo where resourceid = "+id+" order by ID";  
  rs.executeSql(sql);  
%>
	<TR> 
      <TD vAlign=top> 
        <TABLE width="100%" cols=6 id="oTable" class=ListStyle cellspacing=1 >
          <COLGROUP> 
   		    <COL width=3%> 
		    <COL width=12%> 
			<COL width=10%>
			<COL width=30%>
			<COL width=15%>
			<COL width=30%>
	      <TBODY>
		  <input class=inputstyle type=hidden name=rownum>	  
          <TR class=Header> 
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(814,user.getLanguage())%></TH>
	    <Td align=right colspan=4>
	    <BUTTON class=btnNew type="button" accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
	    <BUTTON class=btnDelete type="button" accessKey=D onClick="javascript:if(isdel()){deleteRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>  	    
           </Td>
          </TR>
          <TR class=spacing style="display:none">
        <TD class=Sep1 colspan=5></TD>
        </TR>
            <tr class=Header>
            <td ></td>
		    <td ><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(1944,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(1914,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>	</td>
		  </tr>

<%
  int rownum = 0;
  while(rs.next()){
    String member = Util.null2String(rs.getString("member"));
	String title = Util.null2String(rs.getString("title"));
	String company = Util.null2String(rs.getString("company"));
	String jobtitle = Util.null2String(rs.getString("jobtitle"));
	String address = Util.null2String(rs.getString("address"));
%>
	      <tr>
            <td>
             <input class=inputstyle type='checkbox' name='check_node' value='0'>
           </td>
	        <TD class=Field> 
              <input class=inputstyle type=text  name="member_<%=rownum%>" value="<%=member%>">
            </TD>
	        <TD class=Field> 
              <input class=inputstyle type=text  name="title_<%=rownum%>" value="<%=title%>">
            </TD>
	        <TD class=Field> 
              <input class=inputstyle type=text  name="company_<%=rownum%>" value="<%=company%>">
            </TD>
	        <TD class=Field> 
              <input class=inputstyle type=text  name="jobtitle_<%=rownum%>" value="<%=jobtitle%>">
            </TD>
	        <TD class=Field> 
              <input class=inputstyle type=text  name="address_<%=rownum%>" value="<%=address%>">
            </TD>
	      </tr> 
<%
	rownum++;
  }
%>
<%----------------------------自定义明细字段 begin--------------------------------------------%>

	 <%

         RecordSet.executeSql("select id, formlabel from cus_treeform where viewtype='1' and parentid="+scopeId+" order by scopeorder");
         //System.out.println("select id from cus_treeform where parentid="+scopeId);
         int recorderindex = 0 ;
         while(RecordSet.next()){
             recorderindex = 0 ;
             int subId = RecordSet.getInt("id");
             CustomFieldManager cfm2 = new CustomFieldManager("HrmCustomFieldByInfoType",subId);
             cfm2.getCustomFields();
             CustomFieldTreeManager.getMutiCustomData("CareerCustomFieldByInfoType", subId, Util.getIntValue(id,0));
             int colcount1 = cfm2.getSize() ;
             int colwidth1 = 0 ;

             if( colcount1 != 0 ) {
                 colwidth1 = 95/colcount1 ;

     %>
	 <table Class=ListStyle  cellspacing="0" cellpadding="0">
        <tr class=header>

            <td align="left" >
            <b><%=RecordSet.getString("formlabel")%></b>
            </td>
            <td align="right"  >
            <BUTTON Class=Btn type="button" type=button accessKey=A onclick="addRow_<%=subId%>()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
            <BUTTON class=btnDelete type="button" accessKey=D onClick="if(isdel()){deleteRow_<%=subId%>();}"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            </td>
        </tr>

        <tr>
            <td colspan=2>

            <table Class=ListStyle id="oTable_<%=subId%>"  cellspacing="1" cellpadding="0">
            <COLGROUP>
            <tr class=header>
            <td width="5%">&nbsp;</td>
   <%

       while(cfm2.next()){
		  String fieldlable =String.valueOf(cfm2.getLable());

   %>
		 <td width="<%=colwidth1%>%" nowrap><%=fieldlable%></td>
           <%
	   }
       cfm2.beforeFirst();
%>
</tr>
<%

    boolean isttLight = false;
    while(CustomFieldTreeManager.nextMutiData()){
            isttLight = !isttLight ;
%>
            <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
            <td width="5%"><input class=InputStyle type='checkbox' name='check_node_<%=subId%>' value='<%=recorderindex%>'></td>
        <%
        while(cfm2.next()){
            String fieldid=String.valueOf(cfm2.getId());  //字段id
            String ismand=cfm2.isMand()?"1":"0";   //字段是否必须输入
            String fieldhtmltype = String.valueOf(cfm2.getHtmlType());
            String fieldtype=String.valueOf(cfm2.getType());
            String fieldvalue =  Util.null2String(CustomFieldTreeManager.getMutiData("field"+fieldid)) ;

            if(ismand.equals("1"))  needinputitems+= ",customfield"+fieldid+"_"+subId+"_"+recorderindex;
            //如果必须输入,加入必须输入的检查中
%>
            <td class=field nowrap style="TEXT-VALIGN: center">
<%
            if(fieldhtmltype.equals("1")){                          // 单行文本框
                if(fieldtype.equals("1")){                          // 单行文本框中的文本
                    if(ismand.equals("1")) {
%>
                        <input class=InputStyle datatype="text" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" onChange="checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')">
                        <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                    }else{
%>
                        <input  class=InputStyle datatype="text" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" size=10>
<%
                    }

                }else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                    if(ismand.equals("1")) {
%>
                        <input class=InputStyle datatype="int" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>"
                            onKeyPress="ItemCount_KeyPress()" onBlur="checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')">
                        <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                    }else{
%>
                        <input  class=InputStyle datatype="int" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
<%
                    }
                }else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                    if(ismand.equals("1")) {
%>
                        <input class=InputStyle datatype="float" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>"
                            onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')">
                        <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                    }else{
%>
                        <input class=InputStyle  datatype="float" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
<%
                    }
                }
            }else if(fieldhtmltype.equals("2")){                     // 多行文本框
                if(ismand.equals("1")) {
%>
                    <textarea class=InputStyle name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>"  onChange="checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')"
                        rows="4" cols="40" style="width:80%" ><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
                    <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                }else{
%>
                    <textarea class=InputStyle name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
<%
                }
            }else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                String showname = "";                                   // 新建时候默认值显示的名称
                String showid = "";                                     // 新建时候默认值

                String newdocid = Util.null2String(request.getParameter("docid"));

                if( fieldtype.equals("37") && !newdocid.equals("")) {
                    if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                    fieldvalue += newdocid ;
                }

                if(fieldtype.equals("2") ||fieldtype.equals("19")){
                    showname=fieldvalue; // 日期时间
                }else if(!fieldvalue.equals("")) {
                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                    sql = "";

                    HashMap temRes = new HashMap();

                    if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")) {    // 多人力资源,多客户,多会议，多文档
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }

                    rs.executeSql(sql);
                    while(rs.next()){
                        showid = Util.null2String(rs.getString(1)) ;
                        String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
                        if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                            temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                        else{
                            //showname += tempshowname ;
                            temRes.put(String.valueOf(showid),tempshowname);
                        }
                    }
                    StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                    String temstkvalue = "";
                    while(temstk.hasMoreTokens()){
                        temstkvalue = temstk.nextToken();

                        if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                            showname += temRes.get(temstkvalue);
                        }
                    }

                }
%>
                    <button class=Browser type="button" onclick="onShowBrowser('<%=fieldid%>_<%=subId%>_<%=recorderindex%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%>"></button>
                    <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><%=showname%>
<%
                if( ismand.equals("1") && fieldvalue.equals("") ){
%>
                       <img src="/images/BacoError_wev8.gif" align=absmiddle>
<%
                }
%>
                    </span> <input type=hidden name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
            }else if(fieldhtmltype.equals("4")) {                    // check框
%>
                <!--xiaofeng,td1464-->
                <input class=InputStyle type=checkbox value=1 name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>0" <%if(fieldvalue.equals("1")){%> checked <%}%> onclick='changecheckbox(this,customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>)'>
                <input type= hidden name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" value="<%=fieldvalue%>">
                
<%
            }else if(fieldhtmltype.equals("5")){                     // 选择框   select
                cfm2.getSelectItem(cfm2.getId());
%>
                <select class=InputStyle name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" class=InputStyle>
<%
                while(cfm2.nextSelect()){
%>
                    <option value="<%=cfm2.getSelectValue()%>" <%=cfm2.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm2.getSelectName()%>
<%
                }
%>
                </select>
<%
            }
%>
            </td>
<%
        }
        cfm2.beforeFirst();
        recorderindex ++ ;
    }

%>
</tr>

        </table>
        </td>
        </tr>
</table>
<input type='hidden' id=nodesnum name=nodesnum_<%=subId%> value="<%=recorderindex%>">

<script>
                function changecheckbox(obj,obj1){
                if(obj.checked)
                obj1.value='1'
                else
                obj1.value='0'
               
                }
</script>

<script language=javascript>
var rowindex_<%=subId%> = <%=recorderindex%> ;
var curindex_<%=subId%> = <%=recorderindex%> ;
function addRow_<%=subId%>(){
    oRow = oTable_<%=subId%>.insertRow(rowindex_<%=subId%>+1);

    oCell = oRow.insertCell(-1);
    oCell.style.height=24;
    oCell.style.background= "#E7E7E7";

    var oDiv = document.createElement("div");
    var sHtml = "<input class=InputStyle type='checkbox' name='check_node_<%=subId%>' value='"+rowindex_<%=subId%>+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
<%
    while(cfm2.next()){         // 循环开始
        String fieldhtml = "" ;
        String fieldid=String.valueOf(cfm2.getId());  //字段id
        String ismand=cfm2.isMand()?"1":"0";   //字段是否必须输入
        String fieldhtmltype = String.valueOf(cfm2.getHtmlType());
        String fieldtype=String.valueOf(cfm2.getType());

        if(ismand.equals("1"))  needinputitems+= ",customfield"+fieldid+"_"+subId+"_"+recorderindex;
        //如果必须输入,加入必须输入的检查中

        // 下面开始逐行显示字段

        if(fieldhtmltype.equals("1")){                          // 单行文本框
            if(fieldtype.equals("1")){                          // 单行文本框中的文本
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle datatype='text' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onChange='checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle datatype='text' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' value='' size=10>";
                }
            }else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle  datatype='int' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle datatype='int' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
                }
            }else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle datatype='float' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle datatype='float' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>" ;
                }
            }
        }else if(fieldhtmltype.equals("2")){                     // 多行文本框
            if(ismand.equals("1")) {
                fieldhtml = "<textarea class=InputStyle name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' onChange='checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)' rows='4' cols='40' style='width:80%'></textarea><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
            }else{
                fieldhtml = "<textarea class=InputStyle name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' rows='4' cols='40' style='width:80%'></textarea>" ;
            }
        }else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url

            if (!fieldtype.equals("37")) {    //  多文档特殊处理
                fieldhtml = "<button class=Browser type='button' onclick=\\\"onShowBrowser('" + fieldid + "_"+subId+"_\"+rowindex_"+subId+"+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
            } else {                         // 如果是多文档字段,加入新建文档按钮
                fieldhtml = "<button class=AddDoc type='button' onclick=\\\"onShowBrowser('" + fieldid + "_"+subId+"_\"+rowindex_"+subId+"+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')\\\">" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + "</button>";
            }
            fieldhtml += "<input type=hidden name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' value=''><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'>" ;

            if(ismand.equals("1")) {
                fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>" ;
            }
            fieldhtml += "</span>" ;
        }else if(fieldhtmltype.equals("4")) {                    // check框
            //xiaofeng,td1464
            fieldhtml += "<input class=InputStyle type=checkbox value=1 name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"0'  onclick='changecheckbox(this,customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\")'" ;
            fieldhtml += ">" ;
            fieldhtml += "<input type=hidden value=0 name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' " ;
            fieldhtml += ">" ;
        }else if(fieldhtmltype.equals("5")){                     // 选择框   select
            fieldhtml += "<select class=InputStyle name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' " ;
            fieldhtml += ">" ;

            // 查询选择框的所有可以选择的值
            cfm2.getSelectItem(cfm2.getId());
            while(cfm2.nextSelect()){
                String tmpselectvalue = Util.null2String(cfm2.getSelectValue());
                String tmpselectname = Util.toScreen(cfm2.getSelectName(),user.getLanguage());
                fieldhtml += "<option value='"+tmpselectvalue+"'>"+tmpselectname+"</option>" ;
            }
            fieldhtml += "</select>" ;
        }                                          // 选择框条件结束 所有条件判定结束
%>
    oCell = oRow.insertCell(-1);
    oCell.style.height=24;
    oCell.style.background= "#E7E7E7";

    var oDiv = document.createElement("div");
    var sHtml = "<%=fieldhtml%>" ;
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
<%
    }       // 循环结束
%>
    rowindex_<%=subId%> += 1;
    document.all("nodesnum_<%=subId%>").value = rowindex_<%=subId%> ;
}


function deleteRow_<%=subId%>(){

    len = document.forms[0].elements.length;
    var i=0;
    var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
        if (document.forms[0].elements[i].name=='check_node_<%=subId%>')
            rowsum1 += 1;
    }
    for(i=len-1; i >= 0;i--) {
        if (document.forms[0].elements[i].name=='check_node_<%=subId%>'){
            if(document.forms[0].elements[i].checked==true) {
                oTable_<%=subId%>.deleteRow(rowsum1);
				curindex_<%=subId%>--;
            }
            rowsum1 -=1;
        }
    }
}
</script>
<%
             }
%>
<br>
<%
         }
%>

<%----------------------------自定义明细字段 end  --------------------------------------------%>

      </tbody>
       </table>
   </tr>

   </tbody>
</table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>

 <script language=vbs>
sub onShowEduLevel(inputspan,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	inputspan.innerHtml = id(1)
	inputname.value=id(0)
	else
	inputspan.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub


</script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>
 <script language=javascript>
function onShowBrowser(id,url,linkurl,type1,ismand){
	if (type1== 2 || type1 == 19){
		id1 == window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px");
		jQuery("#customfield"+id+"span]").html(id1);
		jQuery("input[name=customfield"+id+"]").val(id1);
	}else{
		if (type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170){
			id1 = window.showModalDialog(url);
		}else if (type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids);
		}else{
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids);
		}
		if(id1!=null){
			if (type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65){
				if (id1.id!= ""  && id1.id!= "0"){
					ids = id1.id.split(",");
					names =id1.name.split(",");
					sHtml = "";
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
							sHtml = sHtml+"<a target='_blank' href="+linkurl+ids[i]+">"+names[i]+"</a>&nbsp;";
						}
					}
					
					jQuery("#customfield"+id+"span]").html(sHtml);
					
				}else{
					if (ismand==0){
						jQuery("#customfield"+id+"span]").html();
					}else{
						jQuery("#customfield"+id+"span]").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					}
					jQuery("input[name=customfield"+id+"]").val("");
				}

			}else{
			   if  (id1.id!=""   && id1.id!= "0"){
			        if (linkurl == ""){
						jQuery("#customfield"+id+"span]").html(id1.name);
					}else{
						jQuery("#customfield"+id+"span").html("<a target='_blank' href="+linkurl+id1.id+">"+id1.name+"</a>");
					}
					jQuery("input[name=customfield"+id+"]").val(id1.id);
			   }else{
					if (ismand==0){
						jQuery("#customfield"+id+"span]").html();
					}else{
						jQuery("#customfield"+id+"span]").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					}
					jQuery("input[name=customfield"+id+"]").val("");
			   }
			}
		}
	}

}


  function edit(obj){
    obj.disabled = true;
    document.resourcepersonalinfo.operation.value="editper";
    document.resourcepersonalinfo.rownum.value=rowindex;
	document.resourcepersonalinfo.submit();
  }
var rowColor="" ;
rowindex = <%=rownum%>;
function addRow()
{
	ncol = jQuery(oTable).find("tr:nth-child(4)").find("td").length;
	oRow = oTable.insertRow(-1);
	rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_node' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;			
			case 1:
				var oDiv = document.createElement("div");
				var sHtml =  "<input class=inputstyle type=text  name='member_"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type=text  name='title_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type=text  name='company_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
            case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type=text  name='jobtitle_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		    case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type=text  name='address_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;				
		}
	}
	rowindex = rowindex*1 +1;
	jQuery("#resource")[0].rownum.value = rowindex;
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 1;
    for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	} 
	
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1+1);	
			}
			rowsum1 -=1;
		}	
	}	
}

</script> 
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
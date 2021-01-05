
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="SpecialityComInfo" class="weaver.hrm.job.SpecialityComInfo" scope="page" />
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<HTML>
<%
 String id = request.getParameter("id");  
 int hrmid = user.getUID();

 int isView = Util.getIntValue(request.getParameter("isView"));
 
 int departmentid = user.getUserDepartment();
  
 //boolean ishe = (hrmid == Util.getIntValue(id));
 boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid)); 
%>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(380,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(ishr){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(15687,user.getLanguage())+",javascript:viewPersonalInfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
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

<FORM name=resourceworkinfo id=resource action="HrmResourceOperation.jsp" method=post >

<TABLE class=ViewForm>

	<TBODY>
    <TR>
      <TD vAlign=top>
      <TABLE width="100%">
        <COLGROUP> <COL width=20%> <COL width=80%>
	      <TBODY>
          <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15688,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:2px">
            <TD class=line1 colSpan=2></TD>
          </TR>


<%
	int scopeId = 3;
	String sql = "";
    CustomFieldManager cfm = new CustomFieldManager("CareerCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    cfm.getCustomData(Util.getIntValue(id,0));
    while(cfm.next()){
        String fieldvalue = cfm.getData("field"+cfm.getId());
%>
    <tr>
      <td <%if(cfm.getHtmlType().equals("2")){%> valign=top <%}%>> <%=cfm.getLable()%> </td>
      <td class=field >
      <%
        if(cfm.getHtmlType().equals("1")||cfm.getHtmlType().equals("2")){
      %>
      <%=fieldvalue%>
      <%
        }else if(cfm.getHtmlType().equals("3")){

            String fieldtype = String.valueOf(cfm.getType());
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值


            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")) {
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                sql = "";

                HashMap temRes = new HashMap();

                if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
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
        <span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%></span>
       <%
        }else if(cfm.getHtmlType().equals("4")){
       %>
        <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> disabled >
       <%
        }else if(cfm.getHtmlType().equals("5")){
            cfm.getSelectItem(cfm.getId());
       %>
       <%
            while(cfm.nextSelect()){
                if(cfm.getSelectValue().equals(fieldvalue)){
       %>
            <%=cfm.getSelectName()%>
       <%
                    break;
                }
            }
       %>
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

	     </tbody>
      </table>

<%
  sql = "select * from HrmLanguageAbility where resourceid = "+id+" order by ID";  
  rs.executeSql(sql);  
%>
        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP> 
		    <COL width=30%> 
			<COL width=20%>			
			<COL width=50%>
	      <TBODY> 
          <TR class=Header> 
            <TH colSpan=5><%=SystemEnv.getHtmlLabelName(815,user.getLanguage())%></TH>
          </TR>
            <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(15715,user.getLanguage())%></td>			
			<td ><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
		  </tr> 
          <TR class=Line><TD colspan="3" ></TD></TR> 
<%
  while(rs.next()){
    String language = Util.null2String(rs.getString("language"));
	String level = Util.null2String(rs.getString("level_n"));
	String memo = Util.null2String(rs.getString("memo"));
%>
	      <tr>
	        <TD class=Field> 
              <%=language%>
            </TD>	        
	        <TD class=Field> 
                <%if (level.equals("0")) {%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
                <%if (level.equals("1")) {%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%><%}%>
				<%if (level.equals("2")) {%><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%><%}%>
                <%if (level.equals("3")) {%><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%><%}%>
            </TD>
	        <TD class=Field> 
              <%=memo%>
            </TD>            	       
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>
  
<%
  sql = "select * from HrmEducationInfo where resourceid = "+id+" order by ID";  
  rs.executeSql(sql);  
%>
        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br> 
          <COLGROUP> 
		    <COL width=25%> 
			<COL width=25%>
			<COL width=10%>
			<COL width=10%>
			<COL width=10%>
            <COL width=30%>
	      <TBODY> 
          <TR class=Header> 
            <TH colSpan=6><%=SystemEnv.getHtmlLabelName(813,user.getLanguage())%></TH>
          </TR>
          
		  <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(1903,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1942,user.getLanguage())%></td>
		  </tr> 
          <TR class=Line><TD colspan="6" ></TD></TR> 
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("startdate"));
	String enddate = Util.null2String(rs.getString("enddate"));
	String school = Util.null2String(rs.getString("school"));
	String speciality = Util.null2String(rs.getString("speciality"));
	String educationlevel = Util.null2String(rs.getString("educationlevel"));
	String studydesc = Util.null2String(rs.getString("studydesc"));
%>
	      <tr>
	        <TD class=Field> 
              <%=school%>
            </TD>
	        <TD class=Field>	         
              <%=SpecialityComInfo.getSpecialityname(speciality)%>
            </TD>
	        <TD class=Field> 
              <%=startdate%>
            </TD>
	        <TD class=Field> 
              <%=enddate%>
            </TD>
	        <TD class=Field>
	            <%=EduLevelComInfo.getEducationLevelname(educationlevel)%>             
            </TD>
	        <TD class=Field> 
              <%=studydesc%>
            </TD>
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>
  
   
<%
  sql = "select * from HrmWorkResume where resourceid = "+id+" order by ID";  
  rs.executeSql(sql);  
%>

        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP> 
		    <COL width=15%> 
			<COL width=10%>
			<COL width=10%>
			<COL width=10%>
			<COL width=35%>
            <COL width=30%>
	      <TBODY> 
          <TR class=Header> 
            <TH colSpan=6><%=SystemEnv.getHtmlLabelName(15716,user.getLanguage())%></TH>
          </TR>
         
		  <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1977,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(15676,user.getLanguage())%></td>
		  </tr> 
          <TR class=Line><TD colspan="6" ></TD></TR> 
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("startdate"));
	String enddate = Util.null2String(rs.getString("enddate"));
	String company = Util.null2String(rs.getString("company"));
	String jobtitle = Util.null2String(rs.getString("jobtitle"));
	String leavereason = Util.null2String(rs.getString("leavereason"));
	String workdesc = Util.null2String(rs.getString("workdesc"));
%>
	      <tr>
	        <TD class=Field> 
              <%=company%>
            </TD>
	        <TD class=Field> 
              <%=jobtitle%>
            </TD>
	        <TD class=Field> 
              <%=startdate%>
            </TD>
	        <TD class=Field> 
              <%=enddate%>
            </TD>
	        <TD class=Field> 
              <%=workdesc%>
            </TD>
	        <TD class=Field> 
              <%=leavereason%>
            </TD>
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>



<%
  sql = "select * from HrmTrainBeforeWork where resourceid = "+id+" order by ID";  
  rs.executeSql(sql);  
%>

        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP> 
		    <COL width=25%> 
			<COL width=10%>
			<COL width=10%>
			<COL width=20%>
			<COL width=35%>
	      <TBODY> 
          <TR class=header> 
            <TH colSpan=5><%=SystemEnv.getHtmlLabelName(15717,user.getLanguage())%></TH>
          </TR>
         
		  <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(15678,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1974,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
		  </tr> 
          <TR class=Line><TD colspan="5" ></TD></TR> 
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("trainstartdate"));
	String enddate = Util.null2String(rs.getString("trainenddate"));
	String trainname = Util.null2String(rs.getString("trainname"));
	String trainresource = Util.null2String(rs.getString("trainresource"));	
	String trainmemo = Util.null2String(rs.getString("trainmemo"));
%>
	      <tr>
	        <TD class=Field> 
              <%=trainname%>
            </TD>	        
	        <TD class=Field> 
              <%=startdate%>
            </TD>
	        <TD class=Field> 
              <%=enddate%>
            </TD>
            <TD class=Field> 
              <%=trainresource%>
            </TD> 
	        <TD class=Field> 
              <%=trainmemo%>
            </TD>	       
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>


<%
  sql = "select * from HrmCertification where resourceid = "+id+" order by ID";  
  rs.executeSql(sql);  
%>

        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP> 
		    <COL width=25%> 
			<COL width=10%>
			<COL width=10%>
			<COL width=20%>
			<COL width=35%>
	      <TBODY> 
          <TR class=Header> 
            <TH colSpan=5><%=SystemEnv.getHtmlLabelName(1502,user.getLanguage())%></TH>
          </TR>
          
		  <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(15681,user.getLanguage())%></td>			
		  </tr> 
          <TR class=Line><TD colspan="5" ></TD></TR> 
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("datefrom"));
	String enddate = Util.null2String(rs.getString("dateto"));
	String cername = Util.null2String(rs.getString("certname"));
	String cerresource = Util.null2String(rs.getString("awardfrom"));	
	
%>
	      <tr>
	        <TD class=Field> 
              <%=cername%>
            </TD>	        
	        <TD class=Field> 
              <%=startdate%>
            </TD>
	        <TD class=Field> 
              <%=enddate%>
            </TD>
            <TD class=Field> 
              <%=cerresource%>
            </TD> 	    
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>


<%
  sql = "select * from HrmRewardBeforeWork where resourceid = "+id+" order by ID";  
  rs.executeSql(sql);  
%>

        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP> 
		    <COL width=15%> 
			<COL width=10%>
			<COL width=10%>
			<COL width=10%>
			<COL width=35%>
	      <TBODY> 
          <TR class=header> 
            <TH colSpan=5><%=SystemEnv.getHtmlLabelName(15718,user.getLanguage())%></TH>
          </TR>
          
		  <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(15666,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(1962,user.getLanguage())%></td>			
			<td ><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
		  </tr> 
          <TR class=Line><TD colspan="5" ></TD></TR> 
<%
  while(rs.next()){
    String rewarddate = Util.null2String(rs.getString("rewarddate"));
	String rewardname = Util.null2String(rs.getString("rewardname"));
	String rewardmemo = Util.null2String(rs.getString("rewardmemo"));
%>
	      <tr>
	        <TD class=Field> 
              <%=rewardname%>
            </TD>	        
	        <TD class=Field> 
              <%=rewarddate%>
            </TD>
	        <TD class=Field> 
              <%=rewardmemo%>
            </TD>            	       
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>
       <br>
<%----------------------------自定义明细字段 begin--------------------------------------------%>

	 <%
         RecordSet.executeSql("select id, formlabel from cus_treeform where parentid="+scopeId+" order by scopeorder");
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
                 colwidth1 = 100/colcount1 ;

     %>
	 <table Class=ListStyle  cellspacing="0" cellpadding="0">
        <tr class=header>

            <td align="left" >
            <b><%=RecordSet.getString("formlabel")%></b>
            </td>
            <td align="right"  >

            </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>
            <td colspan=2>

            <table Class=ListStyle id="oTable_<%=subId%>"  cellspacing="1" cellpadding="0">
            <COLGROUP>
            <tr class=header>
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
        <%
        while(cfm2.next()){
            String fieldid=String.valueOf(cfm2.getId());  //字段id
            String ismand=String.valueOf(cfm2.isMand());   //字段是否必须输入
            String fieldhtmltype = String.valueOf(cfm2.getHtmlType());
            String fieldtype=String.valueOf(cfm2.getType());
            String fieldvalue =  Util.null2String(CustomFieldTreeManager.getMutiData("field"+fieldid)) ;

%>
            <td class=field nowrap style="TEXT-VALIGN: center">
<%
            if(fieldhtmltype.equals("1")||fieldhtmltype.equals("2")){                          // 单行文本框
%>
                <%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>
<%
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

                    if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
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
                    <%=showname%>
<%
            }else if(fieldhtmltype.equals("4")) {                    // check框
%>
                <input type=checkbox disabled value=1 name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" <%if(fieldvalue.equals("1")){%> checked <%}%> >
<%
            }else if(cfm2.getHtmlType().equals("5")){
                cfm2.getSelectItem(cfm2.getId());
                while(cfm2.nextSelect()){
                    if(cfm2.getSelectValue().equals(fieldvalue)){
%>
            <%=cfm2.getSelectName()%>
<%
                        break;
                    }
                }
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

<%
             }
%>
<br>
<%
         }
%>

<%----------------------------自定义明细字段 end  --------------------------------------------%>
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
<script language=javascript>
  function edit(){    
    location = "/hrm/career/HrmCareerApplyWorkEdit.jsp?id=<%=id%>";    
  }
  
  function viewPersonalInfo(){    
    location = "/hrm/career/HrmCareerApplyPerView.jsp?id=<%=id%>";
  }  
  
  function back(){    
    location = "/hrm/career/HrmCareerApplyEdit.jsp?applyid=<%=id%>";
  }  
</script> 
</BODY>
</HTML>
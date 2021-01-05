<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.appdetach.*,weaver.general.GCONST" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.general.IsGovProj,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.hrm.util.html.HtmlElement"%>
<%@ page import="weaver.hrm.util.html.HtmlUtil"%>
<%@ page import="org.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String from = Util.null2String(request.getParameter("from"));
String cmd = Util.null2String(request.getParameter("cmd"));
int userid = user.getUID();
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();//账号类型
boolean issys = false;
boolean isfin = false;
boolean ishr  = false;
String sql = "select hrmid from HrmInfoMaintenance where id = 1";
rs.executeSql(sql);
while(rs.next()){
  int hrmid = Util.getIntValue(rs.getString(1));
  if(userid == hrmid){
    issys = true;
    break;
  }
}
sql = "select hrmid from HrmInfoMaintenance where id = 2";
rs.executeSql(sql);
while(rs.next()){
  int hrmid = Util.getIntValue(rs.getString(1));
  if(userid == hrmid){
    isfin = true;
    break;
  }
}
if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
  ishr = true;
}

//日期控件处理
String startdateselect = Util.null2String(request.getParameter("startdateselect"));
String enddateselect = Util.null2String(request.getParameter("enddateselect")); 
String bepartydateselect = Util.null2String(request.getParameter("bepartydateselect"));
String contractdateselect = Util.null2String(request.getParameter("contractdateselect")); 
String bememberdateselect =Util.null2String(request.getParameter("bememberdateselect"));
String birthdaydateselect =Util.null2String(request.getParameter("birthdaydateselect"));

String hasroles       ="";
String hasseclevel    ="";
String hasjoblevel    ="";
String hasworkroom    ="";
String hastelephone   ="";
String hasstartdate   ="";
String hasenddate     ="";
String hascontractdate="";
String hasbirthday    ="";
String hasaccounttype = "";
String hasage         ="";
String projectable    ="";
String crmable        ="";
String itemable       ="";
String docable        ="";
String workflowable   ="";
String subordinateable="";
String trainable      ="";
String budgetable     ="";
String fnatranable    ="";
String dspperpage     ="";
String hasfolk = "";
String hasnativeplace = "";
String hasregresidentplace = "";
String hasmaritalstatus = "";
String hascertificatenum = "";
String hastempresidentnumber = "";
String hasresidentplace = "";
String hashomeaddress = "";
String hashealthinfo = "";
String hasheight = "";
String hasweight = "";
String haseducationlevel = "";
String hasdegree = "";
String hasusekind = "";
String haspolicy = "";
String hasbememberdate = "";
String hasbepartydate = "";
String hasislabouunion = "";
String hasbankid1 = "";
String hasaccountid1 = "";
String hasaccumfundaccount = "";
String hasloginid = "";
String hassystemlanguage = "";
String departmentStr = "";

RecordSet.executeProc("HrmUserDefine_SelectByID",""+userid);
if(RecordSet.next()){
   hasroles       =Util.fromScreen(RecordSet.getString(17),user.getLanguage());
   hasseclevel    =Util.fromScreen(RecordSet.getString(18),user.getLanguage());
   hasjoblevel    =Util.fromScreen(RecordSet.getString(19),user.getLanguage());
   hasworkroom    =Util.fromScreen(RecordSet.getString(20),user.getLanguage());
   hastelephone   =Util.fromScreen(RecordSet.getString(21),user.getLanguage());
   hasstartdate   =Util.fromScreen(RecordSet.getString(22),user.getLanguage());
   hasenddate     =Util.fromScreen(RecordSet.getString(23),user.getLanguage());
   hascontractdate=Util.fromScreen(RecordSet.getString(24),user.getLanguage());
   hasbirthday    =Util.fromScreen(RecordSet.getString(25),user.getLanguage());
   hasage         =Util.fromScreen(RecordSet.getString("hasage"),user.getLanguage());
	 hasfolk = Util.fromScreen(RecordSet.getString("hasfolk"),user.getLanguage());
	 hasnativeplace = Util.fromScreen(RecordSet.getString("hasnativeplace"),user.getLanguage());
	 hasregresidentplace = Util.fromScreen(RecordSet.getString("hasregresidentplace"),user.getLanguage());
	 hasmaritalstatus = Util.fromScreen(RecordSet.getString("hasmaritalstatus"),user.getLanguage());
	 hascertificatenum = Util.fromScreen(RecordSet.getString("hascertificatenum"),user.getLanguage());
	 hastempresidentnumber = Util.fromScreen(RecordSet.getString("hastempresidentnumber"),user.getLanguage());
	 hasresidentplace = Util.fromScreen(RecordSet.getString("hasresidentplace"),user.getLanguage());
	 hashomeaddress = Util.fromScreen(RecordSet.getString("hashomeaddress"),user.getLanguage());
	 hashealthinfo = Util.fromScreen(RecordSet.getString("hashealthinfo"),user.getLanguage());
	 hasheight = Util.fromScreen(RecordSet.getString("hasheight"),user.getLanguage());
	 hasweight = Util.fromScreen(RecordSet.getString("hasweight"),user.getLanguage());
	 haseducationlevel = Util.fromScreen(RecordSet.getString("haseducationlevel"),user.getLanguage());
	 hasdegree = Util.fromScreen(RecordSet.getString("hasdegree"),user.getLanguage());
	 hasusekind = Util.fromScreen(RecordSet.getString("hasusekind"),user.getLanguage());
	 haspolicy = Util.fromScreen(RecordSet.getString("haspolicy"),user.getLanguage());
	 hasbememberdate = Util.fromScreen(RecordSet.getString("hasbememberdate"),user.getLanguage());
	 hasbepartydate = Util.fromScreen(RecordSet.getString("hasbepartydate"),user.getLanguage());
	 hasislabouunion = Util.fromScreen(RecordSet.getString("hasislabouunion"),user.getLanguage());
	 hasbankid1 = Util.fromScreen(RecordSet.getString("hasbankid1"),user.getLanguage());
	 hasaccountid1 = Util.fromScreen(RecordSet.getString("hasaccountid1"),user.getLanguage());
	 hasaccumfundaccount = Util.fromScreen(RecordSet.getString("hasaccumfundaccount"),user.getLanguage());
	 hasloginid = Util.fromScreen(RecordSet.getString("hasloginid"),user.getLanguage());
	 hassystemlanguage = Util.fromScreen(RecordSet.getString("hassystemlanguage"),user.getLanguage());

}
	HrmSearchComInfo.initSearchParam(userid,user.getLanguage(),request);
	int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);
	String jobtitle     = HrmSearchComInfo.getJobtitle();
	String roles        = HrmSearchComInfo.getRoles();
	String seclevel     = HrmSearchComInfo.getSeclevel();
	String seclevelTo   = HrmSearchComInfo.getSeclevelTo();
	String joblevel     = HrmSearchComInfo.getJoblevel();
	String joblevelTo   = HrmSearchComInfo.getJoblevelTo();
	String workroom     = HrmSearchComInfo.getWorkroom();
	String telephone    = HrmSearchComInfo.getTelephone();
	String startdate    = HrmSearchComInfo.getStartdate();
	String startdateTo  = HrmSearchComInfo.getStartdateTo();
	String enddate      = HrmSearchComInfo.getEnddate();
	String enddateTo    = HrmSearchComInfo.getEnddateTo();
	String contractdate = HrmSearchComInfo.getContractdate();//试用期结束日期
	String contractdateTo = HrmSearchComInfo.getContractdateTo();
	String birthdaydate   = HrmSearchComInfo.getBirthdaydate();
	String birthdaydateTo = HrmSearchComInfo.getBirthdaydateTo();
	String age            = HrmSearchComInfo.getAge();
	String ageTo          = HrmSearchComInfo.getAgeTo();
	String sex            = HrmSearchComInfo.getSex();
	int accounttype =  HrmSearchComInfo.getAccounttype();
	String resourceidfrom     = HrmSearchComInfo.getResourceidfrom();
	String resourceidto       = HrmSearchComInfo.getResourceidto();
	String folk               = HrmSearchComInfo.getFolk();
	String nativeplace        = HrmSearchComInfo.getNativeplace();
	String regresidentplace   = HrmSearchComInfo.getRegresidentplace();
	String maritalstatus      = HrmSearchComInfo.getMaritalstatus();
	String certificatenum     = HrmSearchComInfo.getCertificatenum();
	String tempresidentnumber = HrmSearchComInfo.getTempresidentnumber();
	String residentplace      = HrmSearchComInfo.getResidentplace();
	String homeaddress        = HrmSearchComInfo.getHomeaddress();
	String healthinfo         = HrmSearchComInfo.getHealthinfo();
	String heightfrom         = HrmSearchComInfo.getHeightfrom();
	String heightto           = HrmSearchComInfo.getHeightto();
	String weightfrom         = HrmSearchComInfo.getWeightfrom();
	String weightto           = HrmSearchComInfo.getWeightto();
	String educationlevel     = HrmSearchComInfo.getEducationlevel();
	String educationlevelTo   = HrmSearchComInfo.getEducationlevelTo();
	String degree             = HrmSearchComInfo.getDegree();
	String usekind            = HrmSearchComInfo.getUsekind();
	String policy             = HrmSearchComInfo.getPolicy();
	String bememberdatefrom   = HrmSearchComInfo.getBememberdatefrom();
	String bememberdateto     = HrmSearchComInfo.getBememberdateto();
	String bepartydatefrom    = HrmSearchComInfo.getBepartydatefrom();
	String bepartydateto      = HrmSearchComInfo.getBepartydateto();
	String islabouunion       = HrmSearchComInfo.getIslabouunion();
	String bankid1            = HrmSearchComInfo.getBankid1();
	String accountid1         = HrmSearchComInfo.getAccountid1();
	String accumfundaccount   = HrmSearchComInfo.getAccumfundaccount();
	String loginid            = HrmSearchComInfo.getLoginid();
	String systemlanguage     = HrmSearchComInfo.getSystemlanguage();
%>
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
<%if(software.equals("ALL") || software.equals("HRM")){%>
				 <%if(ishr){%>
				 <wea:group context='<%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','isColspan':'false','groupOperDisplay':'none'}">
				 <%if(hasbirthday.equals("1") && (mouldid==0||!(birthdaydate.equals(""))||!(birthdaydateTo.equals("0")))){%>
         <wea:item><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></wea:item>
         <wea:item>
          <span>
		      	<select name="birthdaydateselect" id="birthdaydateselect" onchange="changeDate(this,'spanbirthdaydate');" style="width: 135px">
		      		<option value="0" <%=birthdaydateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
		      		<option value="6" <%=birthdaydateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
		      	</select>
		       </span>
		       <span id=spanbirthdaydate style="<%=birthdaydateselect.equals("6")?"":"display:none;" %>">
		      		<BUTTON class=Calendar type="button" id=selectbirthdaydate onclick="getDate(birthdaydatespan,birthdaydate)"></BUTTON>
		       		<SPAN id=birthdaydatespan ><%=birthdaydate%></SPAN>－
		       		<BUTTON class=Calendar type="button" id=selectbirthdaydateTo onclick="getDate(birthdaydateTospan,birthdaydateTo)"></BUTTON>
		       		<SPAN id=birthdaydateTospan ><%=birthdaydateTo%></SPAN>
		       </span>
		       <input class=inputstyle type="hidden" id="birthdaydate" name="birthdaydate" value="<%=birthdaydate%>">
		       <input class=inputstyle type="hidden" id="birthdaydateTo" name="birthdaydateTo" value="<%=birthdaydateTo%>">
         </wea:item>
         <%}if(hasage.equals("1") && (mouldid==0||!(age.equals("0"))||!(ageTo.equals("0")))){%>
         <wea:item><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></wea:item>
         <wea:item>
         	<INPUT class=inputstyle type="text" name=age size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("age")' value="<%=age%>">－
         	<INPUT class=inputstyle name=ageTo type="text" size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("ageTo")' value="<%=ageTo%>">
         </wea:item>
         <%}if(hasfolk.equals("1") && (mouldid==0||!(folk.equals("")))){%>
         <wea:item><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></wea:item>
         <wea:item><INPUT class=inputstyle type="text" name=folk value='<%=folk%>'></wea:item>
         <%}if(hasnativeplace.equals("1") && (mouldid==0||!(nativeplace.equals("")))){%>
         <wea:item><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></wea:item>
         <wea:item><INPUT class=inputstyle type="text" name=nativeplace value='<%=nativeplace%>'></wea:item>
         <%}if(hasregresidentplace.equals("1") && (mouldid==0||!(regresidentplace.equals("")))){%>
         <wea:item><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></wea:item>
         <wea:item><INPUT class=inputstyle type=text name=regresidentplace value='<%=regresidentplace%>'></wea:item>
         <%}if(hasmaritalstatus.equals("1") &&(mouldid==0||!(maritalstatus.equals("")))){%>
         <wea:item><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></wea:item>
         <wea:item>
         	<select class=inputstyle id=maritalstatus name=maritalstatus style="width: 135px">
       	  	<option value="" <% if(maritalstatus.equals("")) {%>selected<%}%>></option>
           	<option value=0 <% if(maritalstatus.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%></option>
           	<option value=1 <% if(maritalstatus.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%></option>
           	<option value=2 <% if(maritalstatus.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%></option>
          </select>
         </wea:item>
         <%}if(hascertificatenum.equals("1") && (mouldid==0||!(certificatenum.equals("")))){%>
         <wea:item><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></wea:item>
         <wea:item><INPUT class=inputstyle type="text" name=certificatenum style="width: 165px" value='<%=certificatenum%>'></wea:item>
         <%}if(hasresidentplace.equals("1") && (mouldid==0||!(residentplace.equals("")))){%>
         <wea:item><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></wea:item>
         <wea:item><INPUT class=inputstyle type="text" name=residentplace size=20 value='<%=residentplace%>'></wea:item>
         <%}
     			int scopeId = 1;
	    		CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
	    		cfm.getCustomFields();
	    		Map customFieldMap=HrmSearchComInfo.getCustomFieldPersonal();
	    		while(cfm.next()){
	        	String fieldvalue = Util.null2String((String)customFieldMap.get(""+cfm.getId()));
	        	if(cfm.getHtmlType().equals("6")||!cfm.isUse())continue;
	        	if(mouldid==0||!("").equals(fieldvalue)){
				 %>
      <wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(cfm.getLable()),user.getLanguage())%></wea:item>
      <wea:item>
      <%
        if(cfm.getHtmlType().equals("1")){
            if(cfm.getType()==1){
      %>
        <input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="column_<%=scopeId%>_<%=cfm.getId()%>" value="" size=20 style="width: 165px">
      <%
            }else if(cfm.getType()==2){
      %>
      <input  datatype="int" type=text  value="<%=fieldvalue%>" class=Inputstyle name="column_<%=scopeId%>_<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' style="width: 165px">
      <%
            }else if(cfm.getType()==3){
      %>
        <input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="column_<%=scopeId%>_<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)' style="width: 165px">
      <%
            }
        }else if(cfm.getHtmlType().equals("2")){
      %>
      	<input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="column_<%=scopeId%>_<%=cfm.getId()%>" value="" size=20 style="width: 165px">
      <%
        }else if(cfm.getHtmlType().equals("3")){
        String fieldtype = String.valueOf(cfm.getType());
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值
		    if("161".equals(fieldtype) || "162".equals(fieldtype)) {
		    	url = url + "?type=" + cfm.getDmrUrl();
		    	if(!"".equals(fieldvalue)) {
			    	Browser browser=(Browser) StaticObj.getServiceByFullname(cfm.getDmrUrl(), Browser.class);
					try{
						String[] fieldvalues = fieldvalue.split(",");
						for(int i = 0;i < fieldvalues.length;i++) {
	                        BrowserBean bb=browser.searchById(fieldvalues[i]);
	                        String desc=Util.null2String(bb.getDescription());
	                        String name=Util.null2String(bb.getName());
	                        if(!"".equals(showname)) {
		                        showname += ",";
	                        }
	                        showname += name;
						}
					}catch (Exception e){}
		    	}
		    }
            String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
            String newdocid = Util.null2String(request.getParameter("docid"));

            if( fieldtype.equals("37") && !newdocid.equals("")) {
                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                fieldvalue += newdocid ;
            }

            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")&& !("161".equals(fieldtype) || "162".equals(fieldtype))) {
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

                RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    showid = Util.null2String(RecordSet.getString(1)) ;
                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals("")&&false)
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
                    	if(showname.length()>0)showname += ",";  
                    	showname += temRes.get(temstkvalue);
                    }
                }

            }


       if(fieldtype.equals("2") ||fieldtype.equals("19")){
	   %>
        <button class=Calendar type="button"
		<%if(fieldtype.equals("2")){%>
		  onclick="onRpDateShow(column_<%=scopeId%>_<%=cfm.getId()%>startspan,column_<%=scopeId%>_<%=cfm.getId()%>start,'0')" 
		<%}else{%>
		  onclick="onRpTimeShow(column_<%=scopeId%>_<%=cfm.getId()%>startspan,column_<%=scopeId%>_<%=cfm.getId()%>start,'0')" 
		<%}%>
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="column_<%=scopeId%>_<%=cfm.getId()%>start" value="<%=fieldvalue%>">
        <span id="column_<%=scopeId%>_<%=cfm.getId()%>startspan"><%=Util.toScreen(showname,user.getLanguage())%>
        </span> －
		<button class=Calendar  type="button"
		<%if(fieldtype.equals("2")){%>
		  onclick="onRpDateShow(column_<%=scopeId%>_<%=cfm.getId()%>endspan,column_<%=scopeId%>_<%=cfm.getId()%>end,'0')" 
		<%}else{%>
		  onclick="onRpTimeShow(column_<%=scopeId%>_<%=cfm.getId()%>endspan,column_<%=scopeId%>_<%=cfm.getId()%>end,'0')" 
		<%}%>
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="column_<%=scopeId%>_<%=cfm.getId()%>end" value="<%=fieldvalue%>">
        <span id="column_<%=scopeId%>_<%=cfm.getId()%>endspan"><%=Util.toScreen(showname,user.getLanguage())%>
        </span>
      <%}else{%>
      	<!-- 
      	<button class=Browser type="button" onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','0','<%=scopeId %>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="column_<%=scopeId%>_<%=cfm.getId()%>" value="<%=fieldvalue%>">
        <span id="column_<%=scopeId%>_<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%>
        </span>
      	 -->
			<%
      	int id=cfm.getId();
        String fieldname="column_"+scopeId+"_"+cfm.getId();
        String type=fieldtype;
      	String eleclazzname=HtmlUtil.getHtmlClassName("3");
      	
        JSONObject hrmFieldConf=new JSONObject();
        hrmFieldConf.put("id", id);
        hrmFieldConf.put("fieldname", fieldname);
        hrmFieldConf.put("fielddbtype", "");
        hrmFieldConf.put("fieldhtmltype", 3);
        hrmFieldConf.put("type", type);
        hrmFieldConf.put("issystem", 0);
        hrmFieldConf.put("fieldkind", "hrmresourcesearch");
        hrmFieldConf.put("ismand", 0);
        hrmFieldConf.put("isused", 1);
        hrmFieldConf.put("dmlurl", cfm.getDmrUrl());
        hrmFieldConf.put("fieldlabel", "");
        hrmFieldConf.put("dsporder", "");
	    	
        %>
      	<%=((HtmlElement)Class.forName(eleclazzname).newInstance()).getHtmlElementString(fieldvalue, hrmFieldConf, user) %>
       <%}
        }else if(cfm.getHtmlType().equals("4")){
       %>
        <input type=checkbox value=1 name="column_<%=scopeId%>_<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> >
       <%
        }else if(cfm.getHtmlType().equals("5")){
            cfm.getSelectItem(cfm.getId());
       %>
       <select class=InputStyle name="column_<%=scopeId%>_<%=cfm.getId()%>" class=InputStyle style="width: 135px">
       <option></option>    
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
       </wea:item>
       
       <%
	    }
		    }%>
      <%if(hasheight.equals("1") && (mouldid==0||!(heightfrom.equals("0"))||!(heightto.equals("0")))){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></wea:item>
      <wea:item>
        <INPUT class=inputstyle type="text" name=heightfrom size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("heightfrom")' value="<%=heightfrom%>" style="width: 50px">
        －<INPUT class=inputstyle type="text" name=heightto size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("heightto")' value="<%=heightto%>" style="width: 50px">
      </wea:item>
      <%}if(hasweight.equals("1") && (mouldid==0||!(weightfrom.equals("0"))||!(weightto.equals("0")))){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></wea:item>
      <wea:item>
        <INPUT class=inputstyle type="text" name=weightfrom size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("weightfrom")' value="<%=weightfrom%>" style="width: 50px">
        －<INPUT class=inputstyle type="text" name=weightto size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("weightto")' value="<%=weightto%>" style="width: 50px">
      </wea:item>
    	<%}if(haseducationlevel.equals("1") && (mouldid==0||!(educationlevel.equals("0"))||!(educationlevelTo.equals("0")))){%>
      <wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%> </wea:item>
      <wea:item>
      <select class=inputstyle id=educationlevel name=educationlevel value="<%=educationlevel%>" style="width: 135px">
      <option value=""></option>
      <%
        EducationLevelComInfo.setTofirstRow();
        while(EducationLevelComInfo.next()){
      %>
      <option value="<%=EducationLevelComInfo.getEducationLevelid()%>" <%if(educationlevel.equals(EducationLevelComInfo.getEducationLevelid())){%> selected <%}%>><%=EducationLevelComInfo.getEducationLevelname()%></option>
      <%
        }
      %>
    	</select>－
    	<select class=inputstyle id=educationlevelto name=educationlevelto value="<%=educationlevelTo%>" style="width: 135px">
      	<option value=""></option>
	      <%
	        EducationLevelComInfo.setTofirstRow();
	        while(EducationLevelComInfo.next()){
	      %>
	      <option value="<%=EducationLevelComInfo.getEducationLevelid()%>" <%if(educationlevelTo.equals(EducationLevelComInfo.getEducationLevelid())){%> selected <%}%>><%=EducationLevelComInfo.getEducationLevelname()%></option>
	      <%
	        }
	      %>
    	</select>
     </wea:item>
     <%}if(hasdegree.equals("1") && (mouldid==0||!(degree.equals("")))){%>
     <wea:item><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></wea:item>
     <wea:item><INPUT type="text" class=inputstyle name=degree size=20 value='<%=degree%>' style="width: 165px">
     </wea:item>
   	 <%}if(hasusekind.equals("1") && (mouldid==0||!(usekind.equals("")))){%>
     <wea:item><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></wea:item>
     <wea:item>
     <brow:browser viewType="0" name="usekind" browserValue='<%= jobtitle %>' 
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp?type=usekind" width="165px"
      browserSpanValue='<%=UseKindComInfo.getUseKindname(usekind)%>'>
	 	 </brow:browser>
     </wea:item>
		 <%}if(haspolicy.equals("1") && (mouldid==0||!(policy.equals("")))){%>
     <wea:item><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></wea:item>
     <wea:item><INPUT type="text" class=inputstyle name=policy size=20 value='<%=policy%>' style="width: 165px"></wea:item>
     <%}if(hasbepartydate.equals("1") && (mouldid==0||!(bepartydatefrom.equals(""))||!(bepartydateto.equals("")))){%>
     <wea:item><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></wea:item>
     <wea:item>
       <span>
      	<select name="bepartydateselect" id="bepartydateselect" onchange="changeDate(this,'spanbepartydate');" style="width: 135px">
      		<option value="0" <%=bepartydateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=bepartydateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=bepartydateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=bepartydateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=bepartydateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=bepartydateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=bepartydateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
       </span>
       <span id=spanbepartydate style="<%=bepartydateselect.equals("6")?"":"display:none;" %>">
	       <BUTTON class=Calendar type="button" id=selectbepartydatefrom onclick="getDate(bepartydatefromspan,bepartydatefrom)"></BUTTON>
	       <SPAN id=bepartydatefromspan ><%=bepartydatefrom%></SPAN> －
	       <BUTTON class=Calendar type="button" id=selectbpartydateto onclick="getDate(bepartydatetospan,bepartydateto)"></BUTTON>
	       <SPAN id=bepartydatetospan ><%=bepartydateto%></SPAN>
       </span>
	 		 <input class=inputstyle type="hidden" name="bepartydatefrom" value="<%=bepartydatefrom%>">
       <input class=inputstyle type="hidden" name="bepartydateto" value="<%=bepartydateto%>">
     </wea:item>
     <%}if(hasbememberdate.equals("1") && (mouldid==0||!(bememberdatefrom.equals(""))||!(bememberdateto.equals("")))){%>
     <wea:item><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></wea:item>
     <wea:item>
       <span>
      	<select name="bememberdateselect" id="bememberdateselect" onchange="changeDate(this,'spanbememberdate');" style="width: 135px">
      		<option value="0" <%=bememberdateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=bememberdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=bememberdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=bememberdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=bememberdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=bememberdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=bememberdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
       </span>
       <span id=spanbememberdate style="<%=bememberdateselect.equals("6")?"":"display:none;" %>">
   			<BUTTON class=Calendar type="button" id=selectbememberdatefrom onclick="getDate(bememberdatefromspan,bememberdatefrom)"></BUTTON>
       	<SPAN id=bememberdatefromspan ><%=bememberdatefrom%></SPAN> －
       	<BUTTON class=Calendar type="button" id=selectbememberdateto onclick="getDate(bememberdatetospan,bememberdateto)"></BUTTON>
       	<SPAN id=bememberdatetospan ><%=bememberdateto%></SPAN>
       </span>
       <input class=inputstyle type="hidden" name="bememberdatefrom" value="<%=bememberdatefrom%>">
       <input class=inputstyle type="hidden" name="bememberdateto" value="<%=bememberdateto%>">
     </wea:item>
     <%}if(hasstartdate.equals("1") && (mouldid==0||!(startdate.equals(""))||!(startdateTo.equals("")))){%>
     <wea:item><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></wea:item>
     <wea:item>
       <span>
      	<select name="startdateselect" id="startdateselect" onchange="changeDate(this,'spanStartdate');" style="width: 135px">
      		<option value="0" <%=startdateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=startdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=startdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=startdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=startdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=startdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=startdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
       </span>
       <span id=spanStartdate style="<%=startdateselect.equals("6")?"":"display:none;" %>">
      		<BUTTON class=Calendar type="button" id=selectstartdate onclick="getstartDate()"></BUTTON>
       		<SPAN id=startdatespan ><%=startdate%></SPAN>－
       		<BUTTON class=Calendar type="button" id=selectstartdateTo onclick="getstartDateTo()"></BUTTON>
       		<SPAN id=startdateTospan ><%=startdateTo%></SPAN>
       </span>
       <input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate%>">
       <input class=inputstyle type="hidden" id="startdateTo" name="startdateTo" value="<%=startdateTo%>">
     </wea:item>
     <%}if(hasenddate.equals("1") && (mouldid==0||!(enddate.equals(""))||!(enddateTo.equals("")))){%>
     <wea:item><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></wea:item>
     <wea:item>
       <span>
      	<select name="enddateselect" id="enddateselect" onchange="changeDate(this,'spanenddate');"  style="width: 135px">
      		<option value="0" <%=enddateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=enddateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=enddateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=enddateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=enddateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=enddateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=enddateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
       </span>
       <span id=spanenddate style="<%=enddateselect.equals("6")?"":"display:none;" %>">
  			<BUTTON class=Calendar type="button" id=selectenddate onclick="getendDate()"></BUTTON>
      	<SPAN id=enddatespan ><%=enddate%></SPAN>－
      	<BUTTON class=Calendar type="button" id=selectenddateTo onclick="getendDateTo()"></BUTTON>
      	<SPAN id=enddateTospan ><%=enddateTo%></SPAN>
       </span>
       <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>">
       <input class=inputstyle type="hidden" name="enddateTo" value="<%=enddateTo%>">
    </wea:item>
    <%}if(hascontractdate.equals("1") && (mouldid==0||!(contractdate.equals(""))||!(contractdateTo.equals("")))){%>
     <wea:item><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></wea:item>
     <wea:item>
       <span>
      	<select name="contractdateselect" id="contractdateselect" onchange="changeDate(this,'spancontractdate');" style="width: 135px">
      		<option value="0" <%=contractdateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=contractdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=contractdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=contractdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=contractdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=contractdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=contractdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
       </span>
       <span id=spancontractdate style="<%=contractdateselect.equals("6")?"":"display:none;" %>">
				<BUTTON class=Calendar type="button" id=selectcontractdate onclick="getcontractDate()"></BUTTON>
      	<SPAN id=contractdatespan ><%=contractdate%></SPAN>－
      	<BUTTON class=Calendar type="button" id=selectcontractdateTo onclick="getcontractDateTo()"></BUTTON>
      	<SPAN id=contractdateTospan ><%=contractdateTo%></SPAN>
       </span>
       <input class=inputstyle type="hidden" name="contractdate" value="<%=contractdate%>">
       <input class=inputstyle type="hidden" name="contractdateTo" value="<%=contractdateTo%>">
		</wea:item>
    <%}if(hashomeaddress.equals("1") && (mouldid==0||!(homeaddress.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(16018,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle type="text" name=homeaddress size=20 value='<%=homeaddress%>'></wea:item>   
    <%}if(hasroles.equals("1") && (mouldid==0||!(roles.equals("0")||roles.equals("")))){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
  	<wea:item>
    <brow:browser viewType="0" name="roles" browserValue='<%= roles %>' 
    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?selectedids="
    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
    completeUrl="/data.jsp?type=65" width="165px"
    browserSpanValue='<%=Util.toScreen(RolesComInfo.getRolesname(roles),user.getLanguage())%>'>
		</brow:browser>
   </wea:item>
   <%}if(hasislabouunion.equals("1") && (mouldid==0||!(islabouunion.equals("")))){%>
   <wea:item><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></wea:item>
   <wea:item>
    <select class=inputstyle id=islabouunion name=islabouunion value="<%=islabouunion%>" style="width: 135px">
     <option value="" <%if(islabouunion.equals("")){%> selected <%}%>></option>
     <option value=1 <%if(islabouunion.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
     <option value=0 <%if(islabouunion.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
    </select>
   </wea:item>
   <%}if(hastempresidentnumber.equals("1") && (mouldid==0||!(tempresidentnumber.equals("")))){%>
  <wea:item><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></wea:item>
  <wea:item><INPUT type="text" class=inputstyle name=tempresidentnumber style="width: 165px" value='<%=tempresidentnumber%>'></wea:item>
  <%}if(hashealthinfo.equals("1") && (mouldid==0||!(healthinfo.equals("")))){%>
  <wea:item><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></wea:item>
  <wea:item>
  <select class=inputstyle id=healthinfo name=healthinfo value="<%=healthinfo%>" style="width: 135px">
    <option value="" <%if(healthinfo.equals("")){%> selected <%}%>></option>
    <option value=0 <%if(healthinfo.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%></option>
    <option value=1 <%if(healthinfo.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option>
    <option value=2 <%if(healthinfo.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
    <option value=3 <%if(healthinfo.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%></option>
  </select>
  </wea:item>
  <%}%>
  </wea:group>
  <%}%>

	<%
	if(isgoveproj==0){
  if( ishr || isfin ) {
  	if(hasaccountid1.equals("1") || hasbankid1.equals("1") || hasaccumfundaccount.equals("1")){
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','isColspan':'false','groupOperDisplay':'none'}">
	<%if(hasaccountid1.equals("1") && (mouldid==0||!(accountid1.equals("")))){%>
   <wea:item><%=SystemEnv.getHtmlLabelName(16016,user.getLanguage())%></wea:item>
   <wea:item><input class=inputstyle type=text name="accountid1" value='<%=accountid1%>' style="width: 165px"></wea:item>
  <%}if(hasbankid1.equals("1") && (mouldid==0||!(bankid1.equals("")))){%>
   <wea:item><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></wea:item>
   <wea:item>
		<brow:browser viewType="0"  name="bankid1" browserValue='<%=bankid1 %>' 
	    browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/finance/bank/BankBrowser.jsp?selectedids="
	    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	    completeUrl="/data.jsp?type=hrmbank" width="165px"
	    browserSpanValue='<%=BankComInfo.getBankname(bankid1)%>'>
    </brow:browser>
   </wea:item>
   <%}if(hasaccumfundaccount.equals("1") && (mouldid==0||!(accumfundaccount.equals("")))){%>
   <wea:item><%=SystemEnv.getHtmlLabelName(1939,user.getLanguage())%></wea:item>
   <wea:item><INPUT class=inputstyle type="text" name=accumfundaccount size=20 style="width: 165px" value='<%=accumfundaccount%>'></wea:item>
  <%}%>  
	</wea:group>
<%}}}}%>

<%
  if(ishr || issys){
  	if(hasseclevel.equals("1")||hasloginid.equals("1")||hassystemlanguage.equals("1")){
%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','isColspan':'false','groupOperDisplay':'none'}">
<%if(hasseclevel.equals("1") && (mouldid==0||!(seclevel.equals("0"))||!(seclevelTo.equals("0")))){%>
	<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
  <wea:item><INPUT class=inputstyle type="text" name=seclevel size=5 maxlength=3  onKeyPress="ItemPlusCount_KeyPress()" onBlur='checknumber("seclevel")' value='<%=seclevel%>' style="width: 50px">-<INPUT class=inputstyle name=seclevelTo size=5 maxlength=3  onKeyPress="ItemPlusCount_KeyPress()" onBlur='checknumber("seclevelTo")' value='<%=seclevelTo%>' style="width: 50px"></wea:item>
  <%}if(hasloginid.equals("1") && (mouldid==0||!(loginid.equals("")))){%>
  <wea:item><%=SystemEnv.getHtmlLabelName(16017,user.getLanguage())%></wea:item>
  <wea:item><INPUT class=inputstyle type="text" name=loginid size=20 value='<%=loginid%>' style="width: 165px"></wea:item>
  <%}if(hassystemlanguage.equals("1") && (mouldid==0||!(systemlanguage.equals("0")))){%>
  <%}if(hassystemlanguage.equals("1") && (mouldid==0||isMultilanguageOK)){%>
	<wea:item><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></wea:item>
	<wea:item>
		<brow:browser viewType="0"  name="systemlanguage" browserValue='<%=""+systemlanguage %>' 
		browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/systeminfo/language/LanguageBrowser.jsp?selectedids="
		hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
		completeUrl="/data.jsp?type=systemlanguage" width="300px"
		browserSpanValue='<%=LanguageComInfo.getLanguagename(""+systemlanguage)%>'>
		</brow:browser>          
	</wea:item>
 <%}%>
</wea:group>
<%}
}
%>
</wea:layout>

<%
//固定页面头部增加以下代码
weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("hrm","HrmResourceBase");
if(CusFormSetting!=null){
	if(CusFormSetting.getStatus()==1){
		//原页面
	}else if(CusFormSetting.getStatus()==2){
		//自定义布局页面
		request.getRequestDispatcher("/hrm/resource/HrmResourceAddTwoNew.jsp").forward(request, response);
		return;
	}else if(CusFormSetting.getStatus()==3){
		//自定义页面
		String page_url = CusFormSetting.getPage_url();
		request.getRequestDispatcher(page_url).forward(request, response);
		return;
	}
}
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ include file="/hrm/resource/uploader.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<% 
if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String f_weaver_belongto_userid = HrmUserVarify.getcheckUserRightUserId("HrmResourceAdd:Add",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=stylesheet>
<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/skins/default/wui_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<script type="text/javascript">
var rowindex = 0;
$(function(){
    $('.e8_box').Tabs({
    	getLine:1,
    	image:false,
    	needLine:false,
    	needTopTitle:false,
    	needInitBoxHeight:true,
    	needNotCalHeight:true
    });
});

jQuery(document).ready(function(){
  //绑定附件上传
  if(jQuery("div[name=uploadDiv]").length>0)
  	jQuery("div[name=uploadDiv]").each(function(){
      bindUploaderDiv($(this),"relatedacc"); 
    });
});
</script>
</HEAD>
<%
LinkedHashMap ht = new LinkedHashMap();
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
int scopeId = 1;
boolean hasFF = true;
RecordSet.executeProc("Base_FreeField_Select","hr");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needinputitems = "";
int rownum = 0;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:doSave(this),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}" ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(15128,user.getLanguage())+",javascript:addRow(),_TOP} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteRow1(),_TOP} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="doSave(this);" value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
/*登录名冲突*/
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>


<FORM name=resource id=resource action="HrmResourceOperation.jsp" method=post >
<input type=hidden name=operation value="addresourcepersonalinfo">
<input class=inputstyle type=hidden name=scopeid value="<%=scopeId%>">
     <input class=inputstyle type=hidden name="rownum">
     <input class=inputstyle type=hidden id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">

<%
  String id = request.getParameter("id");
%>
<input type=hidden name=id value="<%=id%>">
	<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(411,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=wuiDate type="hidden" name="birthday">
    <SPAN id=birthdayspan >
    </SPAN>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></wea:item>
  <wea:item>
    <INPUT class=InputStyle maxLength=30 size=30 name=folk>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=InputStyle maxlength=60 size=30 name=nativeplace>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=InputStyle maxlength=100 size=60 name=regresidentplace>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></wea:item>
  <wea:item>
    <INPUT class=InputStyle maxLength=60 size=30 name=certificatenum>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></wea:item>
  <wea:item>
    <SELECT class=InputStyle id=maritalstatus name=maritalstatus>
      <OPTION value="">
      <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%></OPTION>
      <OPTION value=1><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%></OPTION>
      <OPTION value=2><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%> </OPTION>
    </SELECT>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=InputStyle maxlength=30 size=30 name=policy>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=wuiDate type="hidden" name="bememberdate">
    <span id=bememberdatespan ></span>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=wuiDate type="hidden" name="bepartydate">
    <span id=bepartydatespan ></span>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></wea:item>
  <wea:item>
    <select class=inputstyle name=islabourunion value="1">
      <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
      <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>          </select>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></wea:item>
  <wea:item>
		<brow:browser viewType="0" name="educationlevel" browserValue="" 
    browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/educationlevel/EduLevelBrowser.jsp?selectedids="
    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
    completeUrl="/data.jsp?type=educationlevel" width="120px" browserSpanValue="">
    </brow:browser>
  <!--
  	<INPUT class=wuiBrowser type=hidden name=educationlevel
		_url="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp">
		<SPAN id=educationlevelspan>
		</SPAN> -->
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=InputStyle maxlength=30 size=30  name=degree>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></wea:item>
  <wea:item>
    <select class=InputStyle id=healthinfo name=healthinfo>
      <option value=0 selected><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%></option>
      <option value=1><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option>
      <option value=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
      <option value=3><%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%></option>
    </select>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=InputStyle maxlength=3  size=5 name=height onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("height")'>cm
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=InputStyle maxlength=3  size=5 name=weight onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("weight")'>kg
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=InputStyle maxlength=100 size=60  name=residentplace>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(16018,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=InputStyle maxlength=100 size=30 name=homeaddress>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></wea:item>
  <wea:item>
    <input class=InputStyle maxlength=60 size=30 name=tempresidentnumber>
  </wea:item>
  <%--begin 自定义字段--%>
<%
    String sql = "";
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    cfm.getCustomData(Util.getIntValue(id,0));
    while(cfm.next()){
     if(cfm.isMand()){
         needinputitems += ",customfield"+cfm.getId();
     }
     String fieldvalue = cfm.getData("field"+cfm.getId());
%>
      <wea:item> <%=SystemEnv.getHtmlLabelNames(cfm.getLable(),user.getLanguage())%> </wea:item>
      <wea:item>
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
        }else if(cfm.getHtmlType().equals("6")){
        	int maxsize = 100;
          %>
           <div id="uploadDiv" name="uploadDiv" maxsize="<%=maxsize%>" resourceId="<%=id%>" scopeId="<%=scopeId %>" fieldId="<%=cfm.getId()%>"></div>
           <div>
             <input class=inputstyle type="hidden" id="customfield<%=cfm.getId()%>" name="customfield<%=cfm.getId()%>" value="" onchange='checkinput("customfield<%=cfm.getId()%>","customfield<%=cfm.getId()%>span");'>
           	<SPAN id="customfield<%=cfm.getId()%>span">
         		<%
   							  if(cfm.isMand()) {
   							%>
   							    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
   							<%
   							  }
   							%>
   					</SPAN>
           </div>
          <%} %>
            </wea:item>
       <%
    }
       %>
<%--end 自定义字段--%>
	</wea:group>
      </wea:layout>
  	<!-- tab 测试 -->
<div class="e8_box">
   <ul class="tab_menu">
       	<li class="current">
        	<a href="javascript:void('0');" onclick="jsChangeTab('family')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(814,user.getLanguage()) %>
        	</a>
        </li>
        <% 
        RecordSet.executeSql("select id, formlabel from cus_treeform where parentid="+scopeId+" order by scopeorder");
        while(RecordSet.next()){
            int subId = RecordSet.getInt("id");
            ht.put(("cus_list_"+subId),RecordSet.getString("formlabel"));
        }
        Iterator iter = ht.entrySet().iterator();
				while (iter.hasNext()){
				Map.Entry entry = (Map.Entry) iter.next();
      	String key = (String)entry.getKey();
     		String val = (String)entry.getValue();
     		%>
     		 <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('<%=key %>')" target="_self"><%=val%></a>
         </li>
     		<% }%>
   </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    <div class="tab_box">
<div id="family" class="groupmain" style="width:100%"></div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='member'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1944,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='title'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1914,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='company'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='jobtitle'>"},
{width:"63%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='address'>"}];
var ajaxdata=[];
var option= {
							openindex:true,
              navcolor:"#003399",
              basictitle:"<%=SystemEnv.getHtmlLabelName(814,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              initdatas: ajaxdata,
              addrowCallBack:function() {
								rowindex=this.count;
              },
              copyrowsCallBack:function() {
								rowindex=this.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           $("#family").append(group.getContainer());
       </script>


<%----------------------------自定义明细字段 begin--------------------------------------------%>
	 <%
   String sql = "";
         RecordSet.executeSql("select id, formlabel from cus_treeform where viewtype='1' and parentid="+scopeId+" order by scopeorder");
         //System.out.println("select id from cus_treeform where parentid="+scopeId);
         int recorderindex = 0 ;
         while(RecordSet.next()){
             recorderindex = 0 ;
             int subId = RecordSet.getInt("id");
             CustomFieldManager cfm2 = new CustomFieldManager("HrmCustomFieldByInfoType",subId);
             cfm2.getCustomFields();
             CustomFieldTreeManager.getMutiCustomData("HrmCustomFieldByInfoType", subId, Util.getIntValue(id,0));
             int colcount1 = cfm2.getSize() ;
             int colwidth1 = 0 ;
             int rowcount = 0;
             while(cfm2.next()){
            	 if(!cfm2.isUse())continue;
            	 rowcount++;
             }
             if(rowcount==0)continue;
             cfm2.beforeFirst();
             if( colcount1 != 0 ) {
                 colwidth1 = 95/colcount1 ;
     %>
    <div id="cus_list_<%=subId%>" class="work_groupmaindemo_<%=subId%>" style="width:100%"></div>
	 <table Class=ListStyle  cellspacing="0" cellpadding="0">
        <tr class="DataLight">
            <td style="text-align: right;" colspan="2"  >
            <BUTTON Class=addBtn type=button accessKey=A onclick="addRow_<%=subId%>()"></BUTTON>
            <BUTTON class=delBtn type=button accessKey=D onClick="if(isdel()){deleteRow_<%=subId%>();}"></BUTTON>
            </td>
        </tr>

        <tr>
            <td colspan=2>

            <table Class=ListStyle id="oTable_<%=subId%>" my_title="<%=RecordSet.getString("formlabel")%>"  cellspacing="1" cellpadding="0">
            <COLGROUP>
            <tr class=header>
            <td width="5%">&nbsp;</td>
   <%

       while(cfm2.next()){
      	 if(!cfm2.isUse())continue;
		  String fieldlable =String.valueOf(cfm2.getLable());

   %>
		 <td width="<%=colwidth1%>%" nowrap><%=SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlable),user.getLanguage())%></td>
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
            <td width="5%"><input class="groupselectbox" type='checkbox' name='check_node_<%=subId%>' value='<%=recorderindex%>'></td>
        <%
        while(cfm2.next()){
        	if(!cfm2.isUse())continue;
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
        		    if("161".equals(fieldtype) || "162".equals(fieldtype)) {
        		    	url = url + "?type=" + cfm2.getDmrUrl();
        		    	if(!"".equals(fieldvalue)) {
        			    	Browser browser=(Browser) StaticObj.getServiceByFullname(cfm2.getDmrUrl(), Browser.class);
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
                <input class=InputStyle type=checkbox value=1 name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" <%if(fieldvalue.equals("1")){%> checked <%}%> >
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
<script language=javascript>
var rowindex_<%=subId%> = <%=recorderindex%> ;
var curindex_<%=subId%> = <%=recorderindex%> ;
function addRow_<%=subId%>(group){
    //oRow = oTable_<%=subId%>.insertRow(-1);
 		//oRow.className="DataLight";
 		oRow=document.createElement("tr");
    oCell = oRow.insertCell(-1);
    //oCell.style.height=24;
    //oCell.style.background=getRowBg();

    var sHtml = "<input class='groupselectbox' type='checkbox' name='check_node_<%=subId%>' value='"+rowindex_<%=subId%>+"'>";
    oCell.innerHTML = sHtml;
<%
    while(cfm2.next()){   
    	if(!cfm2.isUse())continue;
    	// 循环开始
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
                    fieldhtml = "<input class=InputStyle datatype='text' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' style='width:90%' onChange='checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle datatype='text' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' value='' style='width:90%'>";
                }
            }else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle  datatype='int' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' style='width:90%' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle datatype='int' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' style='width:90%' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
                }
            }else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle datatype='float' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' style='width:90%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle datatype='float' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' style='width:90%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>" ;
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
    		    if("161".equals(fieldtype) || "162".equals(fieldtype)) {
    		    	url = url + "?type=" + cfm2.getDmrUrl();
    		    }
            if (!fieldtype.equals("37")) {    //  多文档特殊处理
                fieldhtml = "<button class=Browser type='button' onclick=onShowBrowser('" + fieldid + "_"+subId+"_\"+rowindex_"+subId+"+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "') title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
            } else {                         // 如果是多文档字段,加入新建文档按钮
                fieldhtml = "<button class=AddDoc type='button' onclick=onShowBrowser('" + fieldid + "_"+subId+"_\"+rowindex_"+subId+"+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')>" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + "</button>";
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
    oCell.className="field";
    //oCell.style.height=24;
    //oCell.style.background=getRowBg();

    var sHtml = "<%=fieldhtml%>" ;
    oCell.innerHTML = sHtml;
<%
    }       // 循环结束
%>
    rowindex_<%=subId%> += 1;
    jQuery("#nodesnum_<%=subId%>").val(rowindex_<%=subId%>);
    if(group)group.addCustomRow(oRow);
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
<input type="hidden" id="nodesnum_<%=subId%>" name="nodesnum_<%=subId%>" value="<%=recorderindex%>">
<%
             }
%>
<%
         }
%>

<%----------------------------自定义明细字段 end  --------------------------------------------%>
</div>
</div>
  </FORM>
<script type="text/javascript">
jQuery("table[id^='oTable_']").each(function(){
	var tab_index = jQuery(this).attr("id").split("_")[1]; 
	var items=[];
	var ajaxdata = [];
	var cellLen = jQuery(this).find("tr").eq(0).find("td").length;
	var cellWidth = 90/(cellLen-1);
	jQuery(this).find("tr").eq(0).find("td").each(function(index){
		if(jQuery.trim(jQuery(this).text())=="")return;
		//if(index==1)
			//items.push({width:"10px",colname:""+jQuery(this).text()+"",itemhtml:""});
		//else	
			items.push({width:cellWidth+"%",colname:""+jQuery(this).text()+"",itemhtml:""});
	}); 
	var option= {
							openindex:true,
              basictitle:jQuery(this).attr("my_title"),
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              initdatas: ajaxdata,
              addrowtitle:"<%=SystemEnv.getHtmlLabelName(83452,user.getLanguage())%>",
              deleterowstitle:"<%=SystemEnv.getHtmlLabelName(83453,user.getLanguage())%>",
              container: ".work_groupmaindemo_"+tab_index,
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_work" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           group.getContainer().find(".additem").unbind();
           
           group.getContainer().find(".additem").click(function(){
             window["addRow_"+tab_index](group);
           });
  	//增加行
   	jQuery(this).find("tr").each(function(index){
    if(index==0)return;
		group.addCustomRow(this);
	});   
	jQuery(this).parent().parent().parent().remove();
});
</script>
<script language=vbs>
sub onShowBrowser1(id,url,linkurl,type1,ismand)
    spanname = "customfield"+id+"span"
	inputname = "customfield"+id
	if type1= 2 or type1 = 19 then
		if type1 = 2 then
		 onShowADTDate id
		else
		 onShowTime spanname,inputname
		end if
	else
		if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("customfield"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		else
			tmpids = document.all("customfield"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
		end if
		if NOT isempty(id1) then
			if type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("customfield"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("customfield"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						document.all("customfield"+id+"span").innerHtml = empty
					else
						document.all("customfield"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("customfield"+id).value=""
				end if

			else
			   if  id1(0)<>""   and id1(0)<> "0"  then
			        if linkurl = "" then
						document.all("customfield"+id+"span").innerHtml = id1(1)
					else
						document.all("customfield"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
					end if
					document.all("customfield"+id).value=id1(0)
				else
					if ismand=0 then
						document.all("customfield"+id+"span").innerHtml = empty
					else
						document.all("customfield"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("customfield"+id).value=""
				end if
			end if
		end if
	end if

end sub

sub onShowNationality()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	nationalityspan.innerHtml = id(1)
	resource.nationality.value=id(0)
	else
	nationalityspan.innerHtml = ""
	resource.nationality.value=""
	end if
	end if
end sub

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
    spanname = "customfield"+id+"span";
	inputname = "customfield"+id;
	if (type1== 2 || type1 == 19){
		if (type1 == 2){
		 onShowADTDate(id);
		}else{
		 onShowTime(spanname,inputname);
		}
	}else{
		if (type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170&& type1!=168&&type1!=161&&type1!=162){
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids);
		}else if (type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
		}else if (type1==37){
    	tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?documentids="+tmpids)
		}else if (type1==161||type1==162){
      tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"&selectedids="+tmpids)
		}else{
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids)
		}
		if (id1!=null){
			if (type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65|| type1==168){
				if (id1.id!= ""  && id1.id!= "0"){
					ids = id1.id.split(",");
					names =id1.name.split(",");
					sHtml = "";
					id1ids="";
					id1idnum=0;
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
							curid=ids[i];
							curname=names[i];					
							sHtml = sHtml+"<a href="+linkurl+curid+">"+curname+"</a>&nbsp;";
							if(id1idnum==0){
								id1ids=curid;
								id1idnum++;
							}else{
								id1ids=id1ids+","+curid;
								id1idnum++;
							}
						}
					}
					
					jQuery("#customfield"+id+"span").html(sHtml);
					jQuery("input[name=customfield"+id+"]").val(id1ids);					
				}else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
						}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}else{
			   if  (id1.id!="" && id1.id!= "0"){
				   var idT = id1.id;
				   var nameT = id1.name;
			    if (linkurl == ""){
						jQuery("#customfield"+id+"span").html(nameT);
					}else{
						jQuery("#customfield"+id+"span").html("<a href="+linkurl+id1.id+">"+nameT+"</a>");
					}
					jQuery("input[name=customfield"+id+"]").val(idT);
			   }else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}
		}
	}

}

var upfilesnum=0;//获得上传文件总数
function doSave(obj){
  if(check_form(document.resource,'<%=needinputitems%>')) {
  	jQuery("div[name=uploadDiv]").each(function(){
  		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
    	if(oUploader.getStats().files_queued>0){
    		upfilesnum+=oUploader.getStats().files_queued;
    		oUploader.startUpload();
    	}
    });
  	if(upfilesnum==0) doSaveAfterAccUpload(obj);
 	}
}

function doSaveAfterAccUpload(obj){
	jQuery(obj).attr("disabled","disabled");
  document.resource.rownum.value = rowindex;
  document.resource.submit() ;
}
var rowColor="" ;
rowindex = "0";
function addRow()
{
	ncol = jQuery(oTable).find("tr:nth-child(2)").find("td").length;
	oRow = oTable.insertRow(-1);
	//rowColor = getRowBg();

  oRow.className="DataLight";
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.noWrap=true;
		//oCell.style.background= rowColor;
		switch(j) {
      case 0:
        oCell.style.width=10;
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
	document.resource.rownum.value = rowindex;
	jQuery("body").jNice();
}

function deleteRow1()
{
   if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>"))
	var len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 1;
    for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}

	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1);
			}
			rowsum1 -=1;
		}
	}
   }

   function onShowADTDate(id){
	var spanname = "customfield"+id+"span";
	var inputname = "customfield"+id;
	WdatePicker({el:spanname,onpicked:function(dp){
	var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

jQuery(document).ready(function(){
hideAll();
jsChangeTab("family");
})

function hideAll(){
jQuery("#family").hide();
	<% 
	iter = ht.entrySet().iterator();
	while (iter.hasNext()){
	Map.Entry entry = (Map.Entry) iter.next();
	String key = (String)entry.getKey();
	String val = (String)entry.getValue();
	%>
	jQuery("#<%=key %>").hide();
	<% }%>
}

function jsChangeTab(id){
 hideAll();
 jQuery("#"+id).show();
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src='/js/datetime_wev8.js?rnd="+Math.random()+"'></script>
<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
</HTML>

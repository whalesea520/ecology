<%
//固定页面头部增加以下代码
weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("hrm","HrmResourceBase");
if(CusFormSetting!=null){
	if(CusFormSetting.getStatus()==1){
		//原页面
	}else if(CusFormSetting.getStatus()==2){
		//自定义布局页面
		request.getRequestDispatcher("/hrm/resource/HrmResourceAddThreeNew.jsp").forward(request, response);
		return;
	}else if(CusFormSetting.getStatus()==3){
		//自定义页面
		String page_url = CusFormSetting.getPage_url();
		request.getRequestDispatcher(page_url).forward(request, response);
		return;
	}
}
%>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
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
var lanrowindex = 0;
var workrowindex = 0;
var edurowindex = 0;
var trainrowindex = 0;
var rewardrowindex = 0;
var cerrowindex = 0;
$(function(){
    $('.e8_box').Tabs({
    	getLine:1,
    	image:false,
    	needLine:false,
    	needTopTitle:false,
    	needInitBoxHeight:true
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

boolean hasFF = true;
RecordSet.executeProc("Base_FreeField_Select","hr");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();

int scopeId = 3;
String sql = "";
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needinputitems="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+"&"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doSaveNew(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="doSave(this);" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
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
<input class=inputstyle type=hidden name="edurownum">
<input class=inputstyle type=hidden name="workrownum">
<input class=inputstyle type=hidden name="trainrownum">
<input class=inputstyle type=hidden name="rewardrownum">
<input class=inputstyle type=hidden name="cerrownum">
<input class=inputstyle type=hidden name="lanrownum">
<input class=inputstyle type=hidden name="isNewAgain">
<input class=inputstyle type=hidden name=operation value="addresourceworkinfo">
<input class=inputstyle type=hidden id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">
<%
  String id = request.getParameter("id");
%>
        <input class=inputstyle type=hidden name=id value="<%=id%>">
        <input class=inputstyle type=hidden name=scopeid value="<%=scopeId%>">
<wea:layout type="2col">
<wea:group context='<%=SystemEnv.getHtmlLabelName(15688,user.getLanguage())%>'>
<wea:item><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></wea:item>
<wea:item>
	<brow:browser viewType="0" name="usekind" browserValue="" 
	  browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/usekind/UseKindBrowser.jsp?selectedids="
	  hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	  completeUrl="/data.jsp?type=usekind" width="120px" browserSpanValue="">
  </brow:browser>
<!-- 
	<input class=wuiBrowser type=hidden name=usekind 
  _url="/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp">
  <SPAN id=usekindspan></SPAN>
 -->
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></wea:item>
<wea:item>
  <input class=wuiDate type="hidden" name="startdate">
  <SPAN id=startdatespan ></SPAN>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></wea:item>
<wea:item>
  <input class=wuiDate type="hidden" id="probationenddate" name="probationenddate">
  <SPAN id=probationenddatespan ></SPAN>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></wea:item>
<wea:item> 
  <input class=wuiDate type="hidden" name="enddate">
  <SPAN id=enddatespan ></SPAN>
</wea:item>
<%--begin 自定义字段--%>
<%
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
        <button class=Browser type=button onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=cfm.isMand()?"1":"0"%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
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
      </wea:group>
      </wea:layout>
<!-- tab 测试 -->
<div class="e8_box">
   <ul class="tab_menu">
				<li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('lan')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(815,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('edu')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(813,user.getLanguage()) %>
        	</a>
        </li>
       	<li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('work')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(15716,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('train')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(15717,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('cer')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(1502,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="javascript:void('0');" onclick="jsChangeTab('reward')" target="_self">
        		<%=SystemEnv.getHtmlLabelName(15718,user.getLanguage()) %>
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
<div id="lan" class="groupmain" style="width:100%"></div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='language'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(15715,user.getLanguage())%>",itemhtml:"<select class=inputstyle id=level style='width:90%' name='level'><option value=0 selected ><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option><option value=1 ><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option><option value=2 ><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%></option><option value=3 ><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%></option></select>"},
{width:"63%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='memo'>"}];
var option= {
							openindex:true,
              navcolor:"#003399",
              basictitle:"<%=SystemEnv.getHtmlLabelName(815,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              addrowCallBack:function(obj,tr,entry) {
                 //alert("回调函数!!!");
               	lanrowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								lanrowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_lan" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           $("#lan").append(group.getContainer());
       </script>
<div id="edu" class="groupmain" style="width:100%"></div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1903,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:100%' name='school'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%>",itemhtml:"<span class='browser' name='speciality' completeurl='/data.jsp?type=speciality' browserurl='/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/speciality/SpecialityBrowser.jsp' hasInput='true' isSingle='false'></span>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>",itemhtml:"<input type='hidden' name='edustartdate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>",itemhtml:"<input type='hidden' name='eduenddate' class='wuiDate'>"},
{width:"16%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%>",itemhtml:"<span class='browser' name='educationlevel' completeurl='/data.jsp?type=educationlevel' browserurl='/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/educationlevel/EduLevelBrowser.jsp' hasInput='true' isSingle='false'></span>"},
{width:"15%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(1942,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:100%' name='studydesc'>"}];
var option= {
							openindex:true,
              navcolor:"#003399",
              basictitle:"<%=SystemEnv.getHtmlLabelName(813,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
             	addrowCallBack:function(obj,tr,entry) {
								edurowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								edurowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_edu" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           $("#edu").append(group.getContainer());
</script>
<div id="work" class="work_groupmain" style="width:100%"></div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text  style='width:100%' name='company'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>",itemhtml:"<input type='hidden' name='workstartdate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>",itemhtml:"<input type='hidden' name='workenddate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:100%' name='jobtitle'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1977,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:100%' name='workdesc'>"},
{width:"15%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(15676,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:100%' name='leavereason'>"}];
var option= {
							openindex:true,
              navcolor:"#003399",
              basictitle:"<%=SystemEnv.getHtmlLabelName(15716,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              addrowCallBack:function(obj,tr,entry) {
								workrowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								workrowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_work" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           $("#work").append(group.getContainer());
</script>
<div id="train" class="train_groupmain" style="width:100%"></div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(15678,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text  style='width:98%' name='trainname'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(15679,user.getLanguage())%>",itemhtml:"<input type='hidden' name='trainstartdate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(15680,user.getLanguage())%>",itemhtml:"<input type='hidden' name='trainenddate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1974,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='trainresource'>"},
{width:"31%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='trainmemo'>"}];
var option= {
							openindex:true,
              navcolor:"#003399",
              basictitle:"<%=SystemEnv.getHtmlLabelName(15717,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              addrowCallBack:function(obj,tr,entry) {
								trainrowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								trainrowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_train" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           $("#train").append(group.getContainer());
</script>
<div id="cer" class="cer_groupmain" style="width:100%"></div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text  style='width:98%' name='cername'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>",itemhtml:"<input type='hidden' name='cerstartdate' class='wuiDate'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>",itemhtml:"<input type='hidden' name='cerenddate' class='wuiDate'>"},
{width:"47%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(15681,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='cerresource'>"}];
var option= {
							openindex:true,
              navcolor:"#003399",
              basictitle:"<%=SystemEnv.getHtmlLabelName(1502,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              addrowCallBack:function(obj,tr,entry) {
								cerrowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								cerrowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_cer" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           $("#cer").append(group.getContainer());      
</script>
<div id="reward" class="reward_groupmain" style="width:100%"></div>
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(15666,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text  style='width:98%' name='rewardname'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(1962,user.getLanguage())%>",itemhtml:"<input type='hidden' name='rewarddate' class='wuiDate'>"},
{width:"63%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='rewardmemo'>"}];
var option= {
							openindex:true,
              navcolor:"#003399",
              basictitle:"<%=SystemEnv.getHtmlLabelName(15718,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              addrowCallBack:function(obj,tr,entry) {
								rewardrowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								rewardrowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_reward" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           $("#reward").append(group.getContainer());
</script>

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
        <tr class=header>

            <td align="left" >
            <b><%=RecordSet.getString("formlabel")%></b>
            </td>
            <td align="right"  >
            <BUTTON Class=Btn type=button accessKey=A onclick="addRow_<%=subId%>()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></BUTTON>
            <BUTTON class=btnDelete  type=button accessKey=D onClick="if(isdel()){deleteRow_<%=subId%>();}"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></BUTTON>
            </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
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
                    <button class=Browser type=button onclick="onShowBrowser('<%=fieldid%>_<%=subId%>_<%=recorderindex%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%>"></button>
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
<input type='hidden' id=nodesnum_<%=subId%> name=nodesnum_<%=subId%> value="<%=recorderindex%>">


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
                    fieldhtml = "<input class=InputStyle style='width:90%' datatype='text' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onChange='checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle style='width:90%' datatype='text' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' value='' size=10>";
                }
            }else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle  style='width:90%' datatype='int' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle style='width:90%' datatype='int' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
                }
            }else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle style='width:90%' datatype='float' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle style='width:90%' datatype='float' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>" ;
                }
            }
        }else if(fieldhtmltype.equals("2")){                     // 多行文本框
            if(ismand.equals("1")) {
                fieldhtml = "<textarea class=InputStyle style='width:90%' name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' onChange='checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)' rows='4' cols='40' style='width:80%'></textarea><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
            }else{
                fieldhtml = "<textarea class=InputStyle style='width:90%' name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' rows='4' cols='40' style='width:80%'></textarea>" ;
            }
        }else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
    		    if("161".equals(fieldtype) || "162".equals(fieldtype)) {
    		    	url = url + "?type=" + cfm2.getDmrUrl();
    		    }
            if (!fieldtype.equals("37")) {    //  多文档特殊处理
                fieldhtml = "<button class=Browser type='button' onclick=\\\"onShowBrowser('" + fieldid + "_"+subId+"_\"+rowindex_"+subId+"+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
            } else {                         // 如果是多文档字段,加入新建文档按钮
                fieldhtml = "<button class=AddDoc onclick=\\\"onShowBrowser('" + fieldid + "_"+subId+"_\"+rowindex_"+subId+"+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')\\\">" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + "</button>";
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
    //oCell.style.height=24;
    //oCell.style.background=getRowBg();
    oCell.className="field";
    
 
    var sHtml = "<%=fieldhtml%>" ;
    oCell.innerHTML = sHtml;
    
<%
    }       // 循环结束
%>
    rowindex_<%=subId%> += 1;
    jQuery("#nodesnum_<%=subId%>").val(rowindex_<%=subId%>) ;
    //jQuery("body").jNice();
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

</td>
</tr>
</TABLE>
<script type="text/javascript">
jQuery("table[id^='oTable_']").each(function(){
	var tab_index = jQuery(this).attr("id").split("_")[1]; 
	var items=[];
	var cellLen = jQuery(this).find("tr").eq(0).find("td").length;
	var cellWidth = 90/(cellLen-1);
	jQuery(this).find("tr").eq(0).find("td").each(function(index){
		if(jQuery.trim(jQuery(this).text())=="")return;
		//if(index==1)
			//items.push({width:"10px",colname:""+jQuery(this).text()+"",itemhtml:""});
		//else	
			items.push({width:cellWidth+"%",colname:""+jQuery(this).text()+"",itemhtml:""});
	});
	var ajaxdata=[];
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
<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>
<script language=javascript>
edurowindex = "0";
var rowColor="" ;
function addeduRow()
{
	ncol = jQuery(eduTable).find("tr:nth-child(3)").find("td").length;
	oRow = eduTable.insertRow(-1);
  oRow.className="DataLight";
  //rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
        oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  name='check_edu' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='school_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=wuiBrowser _url='/systeminfo/BrowserMain.jsp?url=/hrm/speciality/SpecialityBrowser.jsp' type=hidden name='speciality_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;
			case 3:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getRSDate(edustartdatespan_"+edurowindex+" , edustartdate_"+edurowindex+")' > </BUTTON><SPAN id='edustartdatespan_"+edurowindex+"'></SPAN> <input class=inputstyle type=hidden id='edustartdate_"+edurowindex+"' name='edustartdate_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
         case 4:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getRSDate(eduenddatespan_"+edurowindex+" , eduenddate_"+edurowindex+")' > </BUTTON><SPAN id='eduenddatespan_"+edurowindex+"'></SPAN> <input class=inputstyle type=hidden id='eduenddate_"+edurowindex+"' name='eduenddate_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		 case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=wuiBrowser _url='/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp' type=hidden name='educationlevel_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;
			case 6:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='studydesc_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	jQuery("body").jNice();
	edurowindex = edurowindex*1 +1;
}
function deleteeduRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_edu')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_edu'){
			if(document.forms[0].elements[i].checked==true) {
				eduTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}

workrowindex = "0";

function addworkRow()
{
	ncol = jQuery(workTable).find("tr:nth-child(3)").find("td").length;
	oRow = workTable.insertRow(-1);
	oRow.className="DataLight";
	//rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  name='check_work' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text  style='width:100%' name='company_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
                                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getRSDate(workstartdatespan_"+workrowindex+" , workstartdate_"+workrowindex+")' > </BUTTON><SPAN id='workstartdatespan_"+workrowindex+"'></SPAN> <input class=inputstyle type=hidden id='workstartdate_"+workrowindex+"' name='workstartdate_"+workrowindex+"'>";

				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
			    oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar  type=button id=selectcontractdate onclick='getRSDate(workenddatespan_"+workrowindex+" , workenddate_"+workrowindex+")' > </BUTTON><SPAN id='workenddatespan_"+workrowindex+"'></SPAN> <input class=inputstyle type=hidden id='workenddate_"+workrowindex+"' name='workenddate_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
                        case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='jobtitle_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		        case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='workdesc_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 6:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='leavereason_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	workrowindex = workrowindex*1 +1;
jQuery("body").jNice();
}

function deleteworkRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_work')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_work'){
			if(document.forms[0].elements[i].checked==true) {
				workTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}

trainrowindex = "0";
function addtrainRow()
{
	ncol = jQuery(trainTable).find("tr:nth-child(3)").find("td").length;
	oRow = trainTable.insertRow(-1);
	oRow.className="DataLight";
	//rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  name='check_train' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='trainname_"+trainrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getRSDate(trainstartdatespan_"+trainrowindex+" , trainstartdate_"+trainrowindex+")' > </BUTTON><SPAN id='trainstartdatespan_"+trainrowindex+"'></SPAN> <input class=inputstyle type=hidden id='trainstartdate_"+trainrowindex+"' name='trainstartdate_"+trainrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getRSDate(trainenddatespan_"+trainrowindex+" , trainenddate_"+trainrowindex+")' > </BUTTON><SPAN id='trainenddatespan_"+trainrowindex+"'></SPAN> <input class=inputstyle type=hidden id='trainenddate_"+trainrowindex+"' name='trainenddate_"+trainrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='trainresource_"+trainrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		    case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='trainmemo_"+trainrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	trainrowindex = trainrowindex*1 +1;
jQuery("body").jNice();
}

function deletetrainRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_train')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_train'){
			if(document.forms[0].elements[i].checked==true) {
				trainTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}

rewardrowindex = "0";
function addrewardRow()
{
	ncol = jQuery(rewardTable).find("tr:nth-child(3)").find("td").length;
	oRow = rewardTable.insertRow(-1);
	oRow.className="DataLight";
	//rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_reward'  value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='rewardname_"+rewardrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getRSDate(rewarddatespan_"+rewardrowindex+" , rewarddate_"+rewardrowindex+")' > </BUTTON><SPAN id='rewarddatespan_"+rewardrowindex+"'></SPAN> <input class=inputstyle type=hidden id='rewarddate_"+rewardrowindex+"' name='rewarddate_"+rewardrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='rewardmemo_"+rewardrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rewardrowindex = rewardrowindex*1 +1;
jQuery("body").jNice();
}

function deleterewardRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_reward')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_reward'){
			if(document.forms[0].elements[i].checked==true) {
				rewardTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}

cerrowindex = "0";
function addcerRow()
{
	ncol = jQuery(cerTable).find("tr:nth-child(3)").find("td").length;
	oRow = cerTable.insertRow(-1);
	oRow.className="DataLight";
	//rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  name='check_cer' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='cername_"+cerrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getRSDate(cerstartdatespan_"+cerrowindex+" , cerstartdate_"+cerrowindex+")' > </BUTTON><SPAN id='cerstartdatespan_"+cerrowindex+"'></SPAN> <input class=inputstyle type=hidden id='cerstartdate_"+cerrowindex+"' name='cerstartdate_"+cerrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
                                oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getRSDate(cerenddatespan_"+cerrowindex+" , cerenddate_"+cerrowindex+")' > </BUTTON><SPAN id='cerenddatespan_"+cerrowindex+"'></SPAN> <input class=inputstyle type=hidden id='cerenddate_"+cerrowindex+"' name='cerenddate_"+cerrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
                        case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='cerresource_"+cerrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	cerrowindex = cerrowindex*1 +1;
jQuery("body").jNice();
}

function deletecerRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_cer')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_cer'){
			if(document.forms[0].elements[i].checked==true) {
				cerTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}

lanrowindex = 0;
function addlanRow()
{
	ncol = jQuery(lanTable).find("tr:nth-child(3)").find("td").length;
	oRow = lanTable.insertRow(-1);
    //rowColor = getRowBg();
  oRow.className="DataLight";
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		//oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  name='check_lan' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='language_"+lanrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		    case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle id=level style='width:100%' name='level_"+lanrowindex+"'><option value=0 selected ><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option><option value=1 ><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option><option value=2 ><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%></option><option value=3 ><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%></option></select>"
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='memo_"+lanrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	lanrowindex = lanrowindex*1 +1;
	jQuery("body").jNice();
}
function deletelanRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_lan')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_lan'){
			if(document.forms[0].elements[i].checked==true) {
				lanTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
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
  var checkdate = false;
 	if(document.forms[0].enddate && document.forms[0].startdate)checkdate = true;
  if(checkdate&&document.resource.enddate.value != ""&&document.resource.startdate.value>document.resource.enddate.value){
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16073,user.getLanguage())%>");
  }else{
   jQuery(obj).attr("disabled","disabled");
   document.resource.lanrownum.value = lanrowindex;
   document.resource.rewardrownum.value = rewardrowindex;
   document.resource.workrownum.value = workrowindex;
   document.resource.edurownum.value = edurowindex;
   document.resource.trainrownum.value = trainrowindex;
   document.resource.cerrownum.value = cerrowindex;
   document.resource.submit() ;
  }
}
function doSaveNew(obj) {
  if(document.resource.enddate.value != ""&&document.resource.startdate.value>document.resource.enddate.value){
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16073,user.getLanguage())%>");
  }else{
   obj.disabled = true;
   document.resource.lanrownum.value = lanrowindex;
   document.resource.rewardrownum.value = rewardrowindex;
   document.resource.workrownum.value = workrowindex;
   document.resource.edurownum.value = edurowindex;
   document.resource.trainrownum.value = trainrowindex;
   document.resource.cerrownum.value = cerrowindex;
   document.resource.isNewAgain.value = 1;
   document.resource.submit() ;
 }
}
</script>
<script type="text/javascript">
	function onShowBrowser1(id,url,linkurl,type1,ismand){
		spanname = "customfield"+id+"span";
		inputname = "customfield"+id;
		if(type1 == 2 || type1 == 19){
			if(type1 == 2){
				onShowADTDate(id);
			}else{
				onShowTime(spanname,inputname);
			}
		}else{
			if(type1 != 17 && type1 != 18 && type1 != 27 && type1 != 37 && type1!=56 && type1!=57 
					&& type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170&&type1!=161&&type1!=162){
				tmpids = jQuery("input[name=customfield"+id+"]").val();
				id1 = window.showModalDialog(url+"?resourceids="+tmpids);
			}else if(type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
				tmpids = document.all("customfield"+id).value;
				id1 = window.showModalDialog(url&"?selectedids="&tmpids);
			}else if (type1==37){
        tmpids = jQuery("input[name=customfield"+id+"]").val();
				id1 = window.showModalDialog(url+"?documentids="+tmpids)
			}else if (type1==161||type1==162){
	      tmpids = jQuery("input[name=customfield"+id+"]").val();
	      alert(tmpids);
				id1 = window.showModalDialog(url+"&selectedids="+tmpids)
			}else{
				tmpids = document.all("customfield"+id).value;
				id1 = window.showModalDialog(url&"?resourceids="&tmpids);
			}
			
			if(id1!=null || id1!=""){
				if(type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65){
					if (id1(0)!= ""  && id1(0)!= "0"){
						resourceids = id1(0);
						resourcename = id1(1);
						sHtml = "";
						resourceids = Mid(resourceids,2,len(resourceids));
						document.all("customfield"+id).value= resourceids;
						resourcename = Mid(resourcename,2,len(resourcename));
						while(InStr(resourceids,",") != 0){
							curid = Mid(resourceids,1,InStr(resourceids,",")-1);
							curname = Mid(resourcename,1,InStr(resourcename,",")-1);
							resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids));
							resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename));
							sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
						}
						sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp";
						document.all("customfield"+id+"span").innerHtml = sHtml;
						
					}else{
						if(ismand==0){
							document.all("customfield"+id+"span").innerHtml = empty;
						}else{
							document.all("customfield"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
						}
						document.all("customfield"+id).value="";
					}
				}else{
					if  (id1(0)!="" && id1(0)!= "0"){
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
							document.all("customfield"+id+"span").innerHtml = empty;
						}else{
							document.all("customfield"+id+"span").innerHtml = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
						}
						document.all("customfield"+id).value = "";
					}
				}
			}
		}
	}

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
</script>
<script language=vbs>

sub onShowUsekind()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	usekindspan.innerHtml = id(1)
	resource.usekind.value=id(0)
	else
	usekindspan.innerHtml = ""
	resource.usekind.value=""
	end if
	end if
end sub
sub onShowSpeciality(inputspan,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/speciality/SpecialityBrowser.jsp")
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
</BODY>
<script language=javascript>
function onShowADTDate(id){
	var spanname = "customfield"+id+"span";
	var inputname = "customfield"+id;
	WdatePicker({el:spanname,onpicked:function(dp){
	var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

jQuery(document).ready(function(){
hideAll();
jsChangeTab("lan");
})

function hideAll(){
	jQuery("#lan").hide();
	jQuery("#edu").hide();
	jQuery("#work").hide();
	jQuery("#train").hide();
	jQuery("#cer").hide();
	jQuery("#reward").hide();
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

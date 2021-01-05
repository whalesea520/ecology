
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.systeminfo.*"%>
<%@ page
	import="weaver.general.Util,weaver.docs.docs.CustomFieldManager"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<SCRIPT language="javascript" src="/hrm/area/browser/areabrowser_wev8.js"></script>
<LINK href="/hrm/area/browser/areabrowser.css" type=text/css rel=STYLESHEET>
<%
	User user = HrmUserVarify.getUser(request, response);
	if(user == null)  return ;
	int seccategory = 0;
	seccategory = Util.getIntValue(request.getParameter("seccategory"),
			0);
	StringBuffer taleString = new StringBuffer();
	int tmpcount = 0;
	CustomFieldManager cfm2 = new CustomFieldManager(
		"DocCustomFieldBySecCategory", seccategory);
		cfm2.getCustomFields();
if (seccategory != 0&&cfm2.next()) {	
		
%>
<wea:layout  type="twoCol" >
  <wea:group context="<%=SystemEnv.getHtmlLabelName(84557,user.getLanguage())%>" >

  
  <wea:item type=""><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></wea:item>
  <wea:item ><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>

 <% int linecolor = 0;
		
		CustomFieldManager cfm = new CustomFieldManager(
		"DocCustomFieldBySecCategory", seccategory);
		cfm.getCustomFields();
		while (cfm.next()) {
			tmpcount++;
			String id = String.valueOf(cfm.getId());
			String name = cfm.getFieldDBName();
			String label = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(""+cfm.getPropIdByFieldId(id,seccategory+""),user.getLanguage()));
			String htmltype = cfm.getHtmlType();
			String type = String.valueOf(cfm.getType());
			String fielddbtype=Util.null2String(cfm.getFieldDbType());
			RecordSet.executeSql("select t2.isCond from DocSecCategoryDocProperty  t1,DocSecCategoryCusSearch t2 where t1.id=t2.docpropertyid and t1.secCategoryId="+seccategory+" and t1.fieldid="+id+" and t1.secCategoryId=t2.secCategoryId");
			RecordSet.next();
			int isCond=RecordSet.getInt("iscond");
			if(isCond!=1){
				continue;
			}
%>
  <wea:item>
  <input type='checkbox' name='check_con'   value="<%=cfm.getId() %>" >
  <input type=hidden name="con<%=cfm.getId()%>_id" value="<%=cfm.getId()%>" >
  <input type=hidden name="con<%=cfm.getId()%>_colname" value="<%=name%>" >
  <input type=hidden name="con<%=id %>_htmltype" value="<%=htmltype%>" >
  <input type=hidden name="con<%=id %>_type" value="<%=type%>" >
<%=label%>
  </wea:item>
  <%//htmltype==1 单行文本     htmltype==2 多行文本
  if ((htmltype.equals("1") && type.equals("1"))
			|| htmltype.equals("2")) {
  
  %>
  <wea:item>
   <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel(<%=tmpcount%>)" >
      <option value="1" ><%= SystemEnv.getHtmlLabelName(346, user.getLanguage())%></option>
	  <option value="2" ><%= SystemEnv.getHtmlLabelName(15507, user.getLanguage())%></option>
	 
   </select>
    <input type=text class="inputstyle" size=12 name="con<%=id%>_value"  onfocus="changelevel(<%=tmpcount%>)"  >
  </wea:item>
  <%} else if (htmltype.equals("1") && !type.equals("1")) {%>
  <wea:item>
   <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel(<%=tmpcount%>)" >
      <option value="1" ><%= SystemEnv.getHtmlLabelName(15508, user.getLanguage())%></option>
	  <option value="2" ><%= SystemEnv.getHtmlLabelName(325, user.getLanguage())%></option>
	  <option value="3" ><%= SystemEnv.getHtmlLabelName(15509, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(326, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(327, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(15506, user.getLanguage())%></option>
   </select>
    <input type=text class="inputstyle" size=12 name="con<%=id%>_value1"  onfocus="changelevel(<%=tmpcount%>)"  >
	<select class=inputstyle name="con<%=id%>_opt1"  onfocus="changelevel(<%=tmpcount%>)" >
	  <option value="1" ><%= SystemEnv.getHtmlLabelName(15508, user.getLanguage())%></option>
	  <option value="2" ><%= SystemEnv.getHtmlLabelName(325, user.getLanguage())%></option>
	  <option value="3" ><%= SystemEnv.getHtmlLabelName(15509, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(326, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(327, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(15506, user.getLanguage())%></option>
   </select>
    <input type=text class="inputstyle" size=12 name="con<%=id%>_value"  onfocus="changelevel(<%=tmpcount%>)"  >
  </wea:item>
 <%} else if (htmltype.equals("4")) {%>
  <wea:item>
   <input type=checkbox value=1 class="inputstyle"  name="con<%=id%>_value"  onfocus="changelevel(<%=tmpcount%>)"  >
  </wea:item>
 <%} else if (htmltype.equals("5")) {%>
     <wea:item>
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel(<%=tmpcount%>)" >
      <option value="1" ><%= SystemEnv.getHtmlLabelName(327, user.getLanguage())%></option>
	  <option value="2" ><%= SystemEnv.getHtmlLabelName(15506, user.getLanguage())%></option>
     </select>
	  <select class=inputstyle name="con<%=id%>_value"  onfocus="changelevel(<%=tmpcount%>)" >
	  <%
	   char flag = 2;
		cfm.getSelectItem(cfm.getId());
		while (cfm.nextSelect()) {
			String tmpselectvalue = cfm.getSelectValue();
			String tmpselectname = cfm.getSelectName();
     %>
			<option value="<%=tmpselectvalue%>" >
			<%=Util.toScreen(tmpselectname, user.getLanguage()) %>
			</option>;
	<%
		} 
     
     %>
	  </select>
     </wea:item>
 <%} else if (htmltype.equals("3") && !type.equals("2")
			&& !type.equals("18") && !type.equals("19")
			&& !type.equals("17") && !type.equals("37")
			&& !type.equals("65")&& !type.equals("161") && !type.equals("162")&& !type.equals("278")&& !type.equals("194")&& !type.equals("57")) {%>

	<wea:item>
	<span id="doccreateridselspan1" style="float:left" >
	 <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel(<%=tmpcount%>)" >
      <option value="1" ><%= SystemEnv.getHtmlLabelName(327, user.getLanguage())%></option>
	  <option value="2" ><%= SystemEnv.getHtmlLabelName(15506, user.getLanguage())%></option>
     </select>
    <%
      int sharelevel = 1;
		String browserurl = UrlComInfo.getUrlbrowserurl(type);
		if (type.equals("4") && sharelevel < 2) {
			if (sharelevel == 1)
				browserurl = browserurl.trim()
				+ "?sqlwhere=where subcompanyid1 = "
				+ user.getUserSubCompany1();
			else
				browserurl = browserurl.trim()
				+ "?sqlwhere=where id = "
				+ user.getUserDepartment();
		}
	%>
	</span  >
<%
String con_name="con"+id+"_value";
String javascript_getajaxurl	="javascript:getajaxurl(" + type + ")";
 if(type.equals("263")||type.equals("258")||type.equals("58")){
								  String  areaType="country";
								 if(type.equals("58")){
								    areaType="city";
								 }else if(type.equals("263")){
								   areaType="citytwo";								 
								 }
							 
						%>

                             <div  areaType="<%=areaType%>" style="float:left;width:219px" areaName="<%=con_name%>" areaValue="" 

areaSpanValue=""  areaMustInput="1"  areaCallback="callBack"  class="_areaselect" id="<%=con_name%>"></div>

						<%
							 
							 }else{
							%>
	<span id="doccreateridselspan2" style="width:80%" >
      <brow:browser viewType="0" name="<%=con_name%>" 
            browserValue='<%=request.getParameter(con_name)%>'
            browserSpanValue="" 
            browserUrl="<%=browserurl%>"
            hasInput="true" 
            isSingle="true" 
            hasBrowser = "true" isMustInput='1' 
            completeUrl="<%=javascript_getajaxurl%>"
            > 
          </brow:browser>
	</span>
<%}%>	
  </wea:item>
<%} else if (htmltype.equals("3")
			&& (type.equals("2") || type.equals("19"))) {  %>
   <wea:item>
    <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel(<%=tmpcount%>)" >
	  <option value="1" ><%= SystemEnv.getHtmlLabelName(15508, user.getLanguage())%></option>
	  <option value="2" ><%= SystemEnv.getHtmlLabelName(325, user.getLanguage())%></option>
	  <option value="3" ><%= SystemEnv.getHtmlLabelName(15509, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(326, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(327, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(15506, user.getLanguage())%></option>
   </select>

    <button type='button' class=Browser onfocus="changelevel(<%=tmpcount%>)" onclick="onShowBrowser1(<%=id%>,<%=UrlComInfo.getUrlbrowserurl(type)%>)" > </button>
	<input type=hidden    name="con<%=id%>_value"    >
	<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan" ></span>

	 <select class=inputstyle name="con<%=id%>_opt1"  onfocus="changelevel(<%=tmpcount%>)" >
	  <option value="1" ><%= SystemEnv.getHtmlLabelName(15508, user.getLanguage())%></option>
	  <option value="2" ><%= SystemEnv.getHtmlLabelName(325, user.getLanguage())%></option>
	  <option value="3" ><%= SystemEnv.getHtmlLabelName(15509, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(326, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(327, user.getLanguage())%></option>
	  <option value="4" ><%= SystemEnv.getHtmlLabelName(15506, user.getLanguage())%></option>
   </select>

    <button type='button' class=Browser onfocus="changelevel(<%=tmpcount%>)" onclick="onShowBrowser1(<%=id%>,<%=UrlComInfo.getUrlbrowserurl(type)%>)" > </button>
	<input type=hidden    name="con<%=id%>_value1"    >
	<span name="con<%=id%>_value1span" id="con<%=id%>_value1span" ></span>
   </wea:item>
<%} else if (htmltype.equals("3") && (type.equals("17") || type.equals("18") || type.equals("37") || type.equals("65")|| type.equals("162")|| type.equals("278")|| type.equals("194")|| type.equals("57")  ) ) {%>
    <wea:item>
		<select class=inputstyle name="con<%=id%>_opt" style="float:left"  onfocus="changelevel(<%=tmpcount%>)" >
	  <option value="1" ><%= SystemEnv.getHtmlLabelName(346, user.getLanguage())%></option>
	  <option value="2" ><%= SystemEnv.getHtmlLabelName(15507, user.getLanguage())%></option>
   </select>
   <%
    
		String browserurl = UrlComInfo.getUrlbrowserurl(type);
		browserurl+="?type="+fielddbtype;
		String javascript_getajaxurl	="javascript:getajaxurl(" + type + ")";

   %>
    <brow:browser viewType="0" name='<%="con"+id+"_value"%>' 
            browserValue=''
            browserSpanValue="" 
            browserUrl="<%=browserurl%>"
            hasInput="true" 
            isSingle="false" 
            hasBrowser = "true" isMustInput='1' 
            completeUrl="<%=javascript_getajaxurl%>"
            > 
          </brow:browser>
     </wea:item>
<%}

  			
 }					
%>
   </wea:group>
   </wea:layout>
<%}%>

<script>
jQuery(document).ready(function(){

areromancedivs();

});
</script>
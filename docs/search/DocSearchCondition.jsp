
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />
<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page" />
<jsp:useBean id="ProjectInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%


    int secCategoryId= Util.getIntValue(request.getParameter("secCategoryId"),0);
String urlType = Util.null2String(request.getParameter("urlType"));
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
int userid =user.getUID();
int advanced=Util.getIntValue(request.getParameter("advanced"),0);
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);
String date2durings = "";
if(secCategoryId>0){
	String docsubject="";
	int ownerid = 0;
	int departmentid = 0;

    String whereKeyStr = Util.null2String((String)session.getAttribute(user.getUID()+"_"+secCategoryId+"whereKeyStr"));
    whereKeyStr =whereKeyStr.replaceAll(",","#");
    Map tmpcolnameMap=new HashMap();
	Map tmphtmltypeMap=new HashMap();
	Map tmptypeMap=new HashMap();
	Map tmpoptMap=new HashMap();
	Map tmpvalueMap=new HashMap();
	Map tmpnameMap=new HashMap();
	Map tmpopt1Map=new HashMap();
	Map tmpvalue1Map=new HashMap();

	String tmpid = null;
	String tmpcolname = null;
	String tmphtmltype = null;
	String tmptype = null;
	String tmpopt = null;
	String tmpvalue = null;
	String tmpname = null;
	String tmpopt1 = null;
	String tmpvalue1 =null;

	String whereKeyStrPart=null;
	
    ArrayList whereKeyStrList = Util.TokenizerString(whereKeyStr,"^,^");
	for(int i=0;i<whereKeyStrList.size();i++){
		whereKeyStrPart=Util.null2String((String)whereKeyStrList.get(i));
		if(whereKeyStrPart.indexOf("docsubject=")>=0){
			docsubject=whereKeyStrPart.substring("docsubject=".length());
		}else if(whereKeyStrPart.indexOf("ownerid=")>=0){
			ownerid=Util.getIntValue(whereKeyStrPart.substring("ownerid=".length()),0);
		}else if(whereKeyStrPart.indexOf("departmentid=")>=0){
			departmentid=Util.getIntValue(whereKeyStrPart.substring("departmentid=".length()),0);
		}else{
			if(whereKeyStrPart.indexOf("tmpid")!=-1){
				whereKeyStrPart = whereKeyStrPart.replaceAll("#",",");
			}
				ArrayList whereKeyStrPartList = Util.TokenizerString(whereKeyStrPart,"~@~");
				if(whereKeyStrPartList.size()>=9){
					tmpid=((String)whereKeyStrPartList.get(0)).substring("tmpid=".length());
					tmpcolname=((String)whereKeyStrPartList.get(1)).substring("tmpcolname=".length());
					tmphtmltype=((String)whereKeyStrPartList.get(2)).substring("tmphtmltype=".length());
					tmptype=((String)whereKeyStrPartList.get(3)).substring("tmptype=".length());
					tmpopt=((String)whereKeyStrPartList.get(4)).substring("tmpopt=".length());
					tmpvalue=((String)whereKeyStrPartList.get(5)).substring("tmpvalue=".length());
					tmpname=((String)whereKeyStrPartList.get(6)).substring("tmpname=".length());
					tmpopt1=((String)whereKeyStrPartList.get(7)).substring("tmpopt1=".length());
					tmpvalue1=((String)whereKeyStrPartList.get(8)).substring("tmpvalue1=".length());
	
					tmpcolnameMap.put(tmpid,tmpcolname);
					tmphtmltypeMap.put(tmpid,tmphtmltype);
					tmptypeMap.put(tmpid,tmptype);
					tmpoptMap.put(tmpid,tmpopt);
					tmpvalueMap.put(tmpid,tmpvalue);
					tmpnameMap.put(tmpid,tmpname);
					tmpopt1Map.put(tmpid,tmpopt1);
					tmpvalue1Map.put(tmpid,tmpvalue1);
				}
				
		}
	}

%>
<%if(false){ %>
  <table width=100% class="viewform e8_Noborder" >
    <COLGROUP> 
	<COL width="15%"> 
	<COL width="35%"> 
	<COL width="15%"> 
	<COL width="35%">
    <TR class=title>
      <TH colSpan=4 class="field e8_feaTitle"><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
    </TR>
    <TR style="height: 1px" >
      <TD class=line1 colspan=4></TD>
    </TR>

<%

    Map fieldNameMap=new HashMap();
    Map fieldLabelMap=new HashMap();
    Map fieldHtmlTypeMap=new HashMap();
    Map fieldTypeMap=new HashMap();
    Map fieldDbTypeMap=new HashMap();

    CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",secCategoryId);
    cfm.getCustomFields();
    while(cfm.next()){
        String id = String.valueOf(cfm.getId());
        String name = "field"+cfm.getId();
        String label = cfm.getLable();
        String htmltype = cfm.getHtmlType();
        String type = String.valueOf(cfm.getType());
        String fielddbtype=Util.null2String(cfm.getFieldDbType());
		
		fieldNameMap.put(id,name);
		fieldLabelMap.put(id,label);
		fieldHtmlTypeMap.put(id,htmltype);
		fieldTypeMap.put(id,type);
		fieldDbTypeMap.put(id,fielddbtype);
	}

    
    int tempSecCategoryId=0;
    int tempDocPropertyId=0;
	int tempIsCond=0;
    int tempCondColumnWidth=0;

	int j = 1;
    int tmpcount = 0;
    SecCategoryCustomSearchComInfo.setTofirstRow();
	while(SecCategoryCustomSearchComInfo.next()){

		tempSecCategoryId=Util.getIntValue(SecCategoryCustomSearchComInfo.getSecCategoryId(),0);
		if(tempSecCategoryId!=secCategoryId){
			continue;
		}

		tempIsCond=Util.getIntValue(SecCategoryCustomSearchComInfo.getIsCond(),0);
		if(tempIsCond!=1){
			continue;
		}

		tempDocPropertyId=Util.getIntValue(SecCategoryCustomSearchComInfo.getDocPropertyId(),0);
		tempCondColumnWidth=Util.getIntValue(SecCategoryCustomSearchComInfo.getCondColumnWidth(),0);

			int tempLabelId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(tempDocPropertyId+""));
			String tempCustomName = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(tempDocPropertyId+""));
			
			int tempType = Util.getIntValue(SecCategoryDocPropertiesComInfo.getType(tempDocPropertyId+""));
			
			String tempName = (tempCustomName.equals("")&&tempLabelId>0)?SystemEnv.getHtmlLabelName(tempLabelId, user.getLanguage()):tempCustomName;

			int tempIndexId=tempName.lastIndexOf("("+SystemEnv.getHtmlLabelName(19516,user.getLanguage())+")");
			if(tempIndexId<=0){
				tempIndexId=tempName.lastIndexOf("(user-defined)");
			}
			if(tempIndexId>0){
				tempName=tempName.substring(0,tempIndexId);
			}

			    String id = Util.null2String(SecCategoryDocPropertiesComInfo.getFieldId(tempDocPropertyId+""));

		if(tempCondColumnWidth>1){
			if(j==2){
	%>
			</TR>
			<TR style="height: 1px">
				<TD class=Line colSpan=4></TD>
			</TR>
	<%
			}
			j=3;
		}

	%>
			<% if(j==1||j==3){ %>
			<TR height="18">
			<% } %>

			<td>
<%
				if(tempType==0){

%>
	            <input type='checkbox' name='check_con'  value="<%=id%>" <%if(!"".equals(Util.null2String((String)tmpcolnameMap.get(id)))){%>checked<%}%>>
<%
				}else if(tempType==1){
%>
	            <input type='checkbox' name='check_con_<%=tempType%>'  value="<%=tempType%>" <%if(!"".equals(docsubject)){%>checked<%}%>>
<%
				}else if(tempType==9){//部门
%>
	            <input type='checkbox' name='check_con_<%=tempType%>'  value="<%=tempType%>" <%if(departmentid>0){%>checked<%}%>>
<%
				}else if(tempType==21){//文档所有者
%>
	            <input type='checkbox' name='check_con_<%=tempType%>'  value="<%=tempType%>" <%if(ownerid>0){%>checked<%}%>>
<%
				}
%>
	            <%=tempName%></td>
			<td class=field <%if(j==3){%>colspan="3"<%}%>>
			<%

			if(tempType==1){
%>
	            <input class=InputStyle type="text"  name="docsubject" value="<%=docsubject%>" onfocus="changeCheckConType('<%=tempType%>')">
<%
			}else if(tempType==9){//部门
%>
	            <button type='button' onfocus="changeCheckConType('<%=tempType%>')" class=Browser  onClick="onShowDept('departmentspan','departmentid')"></button>
                          <span id=departmentspan>
                          <%if(departmentid!=0){%>
                          <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="departmentid" value="<%=departmentid%>">
<%
			}else if(tempType==21){//文档所有者
%>
	            <button type='button' onfocus="changeCheckConType('<%=tempType%>')" class=Browser onClick="onShowResourceThisJsp('ownerspan','ownerid')"></button>
						  <span id=ownerspan>

                          <%=Util.toScreen(ResourceComInfo.getResourcename(ownerid+""),user.getLanguage())%>

                          </span>
                            <input type="hidden" name="ownerid" value="<%=ownerid%>">
<%
			}else if(tempType==0){


			    tmpcount ++;

			    String name = Util.null2String((String)fieldNameMap.get(id));
			    String label = Util.null2String((String)fieldLabelMap.get(id));
			    String htmltype = Util.null2String((String)fieldHtmlTypeMap.get(id));
			    String type = Util.null2String((String)fieldTypeMap.get(id));
			    String fielddbtype = Util.null2String((String)fieldDbTypeMap.get(id));

                tmpopt = Util.null2String((String)tmpoptMap.get(id));
                tmpvalue = Util.null2String((String)tmpvalueMap.get(id));
                tmpname = Util.null2String((String)tmpnameMap.get(id));
                tmpopt1 = Util.null2String((String)tmpopt1Map.get(id));
                tmpvalue1 = Util.null2String((String)tmpvalue1Map.get(id));
%>


      

      <input type=hidden name="con<%=id%>_id" value="<%=id%>">
      <input type=hidden name="con<%=id%>_colname" value="<%=name%>">

    <input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
    <input type=hidden name="con<%=id%>_type" value="<%=type%>">
    <%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        <option value="3" <%if("3".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="4" <%if("4".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>

      <input type=text class=inputstyle size=12 name="con<%=id%>_value" value="<%=tmpvalue%>" onfocus="changelevel('<%=tmpcount%>')"  >

    <%}
else if(htmltype.equals("1")&& !type.equals("1")){
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if("3".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if("4".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if("5".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if("6".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

      <input type=text class=inputstyle size=12 name="con<%=id%>_value" value="<%=tmpvalue%>"  onfocus="changelevel('<%=tmpcount%>')" >

      <select class=inputstyle name="con<%=id%>_opt1"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if("3".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if("4".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if("5".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if("6".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

      <input type=text class=inputstyle size=12 name="con<%=id%>_value1" value="<%=tmpvalue1%>"  onfocus="changelevel('<%=tmpcount%>')"  >

    <%
}
else if(htmltype.equals("4")){
%>

      <input type=checkbox value=1 name="con<%=id%>_value" <%if("1".equals(tmpvalue)){%>checked<%}%> onfocus="changelevel('<%=tmpcount%>')" >

    <%}
else if(htmltype.equals("5")){
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>


      <select class=inputstyle name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')">
<%

    cfm.getSelectItem(Util.getIntValue(id,0));
    while(cfm.nextSelect()){
        String tmpselectvalue = cfm.getSelectValue();
        String tmpselectname = cfm.getSelectName();
%>
        <option value="<%=tmpselectvalue%>"  <%if(tmpvalue.equals(tmpselectvalue)){%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%
    }
%>
      </select>

    <%} else if(htmltype.equals("3") && !type.equals("2")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17") && !type.equals("37")&& !type.equals("65")&& !type.equals("161")&& !type.equals("162")){
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

         <%
            //for test
            int sharelevel = 1;
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            if(type.equals("4") && sharelevel <2) {
                if(sharelevel == 1) browserurl = browserurl.trim() + "?sqlwhere="+xssUtil.put("where subcompanyid1 = " + user.getUserSubCompany1()) ;
                else browserurl = browserurl.trim() + "?sqlwhere="+xssUtil.put("where id = " + user.getUserDepartment()) ;
            }
         %>
        <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowDepartment('<%=id%>','<%=browserurl%>')"></button>
        <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
        <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
        String showname="";
        String tablename=BrowserComInfo.getBrowsertablename(type); //浏览框对应的表,比如人力资源表
        String columname=BrowserComInfo.getBrowsercolumname(type); //浏览框对应的表名称字段
        String keycolumname=BrowserComInfo.getBrowserkeycolumname(type);   //浏览框对应的表值字段
		
		String sql=null;
		if(tmpvalue.indexOf(",")!=-1){
			tmpvalue =tmpvalue.substring(1,tmpvalue.length());
			sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+tmpvalue+")";
		}else{
			if(tmpvalue.trim().equals("")){
				tmpvalue="-1";
			}
			sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+tmpvalue;
		}
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
			showname +=tempshowname+" ";
		}
%>
        <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if("3".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if("4".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if("5".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if("6".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

    <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','1')"></button>
      <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpvalue%></span> 

      <select class=inputstyle name="con<%=id%>_opt1"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if("3".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if("4".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if("5".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if("6".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

    <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','2')"></button>
      <input type=hidden name="con<%=id%>_value1" value="<%=tmpvalue1%>">
      <span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span> 
	 </td>
    <%} else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>

 <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
      <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	 String showname="";
     ArrayList tempshowidlist=Util.TokenizerString(tmpvalue,",");
	 for(int k=0;k<tempshowidlist.size();k++){
		 showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
	 }
%>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>

     <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value"value="<%=tmpvalue%>" >
      <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	 String showname="";
     ArrayList tempshowidlist=Util.TokenizerString(tmpvalue,",");
	 for(int k=0;k<tempshowidlist.size();k++){
		 showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
	 }
%>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含） %>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>

       <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
      <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	 String showname="";
     ArrayList tempshowidlist=Util.TokenizerString(tmpvalue,",");
	 for(int k=0;k<tempshowidlist.size();k++){
		 showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
	 }
%>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} else if(htmltype.equals("3") && type.equals("65")){ // 增加多角色的处理（包含，不包含） %>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
		  <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
      <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	 String showname="";
     ArrayList tempshowidlist=Util.TokenizerString(tmpvalue,",");
	 for(int k=0;k<tempshowidlist.size();k++){
		 showname+=RolesComInfo.getRolesRemark((String)tempshowidlist.get(k))+" ";
	 }
%>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} else if(htmltype.equals("3") && type.equals("161")){// 增加自定义多单选的处理（等于，不等于）
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            browserurl+="?type="+fielddbtype;
         %>
        <button class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCommon('<%=id%>','<%=browserurl%>','<%=type%>')"></button>
        <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
        <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
        String showname="";
		String showid =tmpvalue;                                     // 新建时候默认值
		try{
			Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
			BrowserBean bb=browser.searchById(showid);
			String bbdesc=Util.null2String(bb.getDescription());
			String bbname=Util.null2String(bb.getName());
			showname="<a title='"+bbdesc+"'>"+bbname+"</a>&nbsp";
		}catch(Exception e){
		}
%>
        <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%}  else if(htmltype.equals("3") && type.equals("162")){ // 增加自定义多选的处理（包含，不包含） %>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            browserurl+="?type="+fielddbtype;
         %>
		  <button class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCommon('<%=id%>','<%=browserurl%>','<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
      <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	 String showname="";
	 String showid =tmpvalue;                                     // 新建时候默认值
	 try{
		 Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
		 List l=Util.TokenizerString(showid,",");
		 for(int jindex=0;jindex<l.size();jindex++){
			 String curid=(String)l.get(jindex);
			 BrowserBean bb=browser.searchById(curid);
			 String bbname=Util.null2String(bb.getName());
			 String bbdesc=Util.null2String(bb.getDescription());
			 showname+="<a title='"+bbdesc+"'>"+bbname+"</a>&nbsp";
		 }
	 }catch(Exception e){
	 }
%>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} %>

<%
			}
%>
			</td>
			<% if(j==2||j==3){ %>
			</TR>
			<TR style="height: 1px">
				<TD class=Line colSpan=4></TD>
			</TR>
			<% } %>
<%
		j++;
		if(j>2) j=1;
    }
%>
	<% if(j==2){ %>
			</TR>
			<TR style="height: 1px">
				<TD class=Line colSpan=4></TD>
			</TR>
	<% } %>	
  </table>
<%}else{ 
	
String doccontent = "" ;
String containreply = "" ;
int maincategoryid= 0 ;
int subcategoryid= 0 ;
int seccategoryid= secCategoryId ;
int maincategory= 0 ;
int subcategory= 0 ;
int seccategory= 0 ;
int docid= 0 ;
int ownersubcompanyid = 0;
int doclangurage= 0 ;
int hrmresid= 0 ;
int itemid= 0 ;
int itemmaincategoryid= 0 ;
int crmid= 0 ;
int projectid= 0 ;
int financeid= 0 ;
String docpublishtype = "" ;
String docstatus = "" ;
String keyword= "" ;
String contentname="";
int ownerid2= 0 ;   //客户拥有者的id
int date2during = 0;


//seccategoryid =  Util.getIntValue(Util.null2String(request.getParameter("seccategoryid")),0);

String docno = "" ;
String doclastmoddatefrom = "" ;
String doclastmoddateto = "" ;
String docarchivedatefrom = "" ;
String docarchivedateto = "" ;
String doccreatedatefrom = "" ;
String doccreatedateto = "" ;
String docapprovedatefrom = "" ;
String docapprovedateto = "" ;
String replaydoccountfrom = "" ;
String replaydoccountto = "" ;
String accessorycountfrom = "" ;
String accessorycountto = "" ;
String usertype = "" ;
String customSearchPara ="";

String subscribeDateFrom = "";
String subscribeDateTo = "";
String approveDateFrom = "";
String approveDateTo = "";

String dspreply = Util.null2String(request.getParameter("dspreply"));

int doclastmoduserid = 0 ;
int docarchiveuserid = 0 ;
int doccreaterid = 0 ;
int doccreaterid2 = 0 ;  //客户拥有者的id
int docapproveuserid = 0 ;
int assetid = 0 ;

int showtype = 0;
String treeDocTemp="";
String treeDocFieldId="";
int creatersubcompanyid = 0;

int ownerdepartmentid = 0;		
    docsubject = Util.toScreenToEdit(request.getParameter("docsubject"),user.getLanguage());
    	
	ownerdepartmentid = Util.getIntValue(request.getParameter("ownerdepartmentid"),0);
	creatersubcompanyid = Util.getIntValue(request.getParameter("creatersubcompanyid"),0);
	ownersubcompanyid = Util.getIntValue(request.getParameter("ownersubcompanyid"),0);
    doccontent = Util.toScreenToEdit(request.getParameter("doccontent"),user.getLanguage());
    containreply = Util.toScreenToEdit(request.getParameter("containreply"),user.getLanguage());
    maincategory= Util.getIntValue(request.getParameter("maincategory"),0);
    subcategory= Util.getIntValue(request.getParameter("subcategory"),0);
    seccategory= Util.getIntValue(request.getParameter("seccategory"),0);
    docid= Util.getIntValue(request.getParameter("docid"),0);
    departmentid= Util.getIntValue(request.getParameter("departmentid"),0);
    doclangurage= Util.getIntValue(request.getParameter("doclangurage"),0);
    hrmresid= Util.getIntValue(request.getParameter("hrmresid"),0);
    itemid= Util.getIntValue(request.getParameter("itemid"),0);
    itemmaincategoryid= Util.getIntValue(request.getParameter("itemmaincategoryid"),0);
    crmid= Util.getIntValue(request.getParameter("crmid"),0);
    projectid= Util.getIntValue(request.getParameter("projectid"),0);
    financeid= Util.getIntValue(request.getParameter("financeid"),0);
    docpublishtype= Util.toScreenToEdit(request.getParameter("docpublishtype"),user.getLanguage());
    docstatus= Util.toScreenToEdit(request.getParameter("docstatus"),user.getLanguage());
    keyword= Util.toScreenToEdit(request.getParameter("keyword"),user.getLanguage());
	contentname= Util.toScreenToEdit(request.getParameter("contentname"),user.getLanguage());
    ownerid= Util.getIntValue(request.getParameter("ownerid"),0);
    ownerid2= Util.getIntValue(request.getParameter("ownerid2"),0);
   
    docno = Util.toScreenToEdit(request.getParameter("docno"),user.getLanguage());
    doclastmoddatefrom = Util.toScreenToEdit(request.getParameter("doclastmoddatefrom"),user.getLanguage());
    doclastmoddateto = Util.toScreenToEdit(request.getParameter("doclastmoddateto"),user.getLanguage());
    docarchivedatefrom = Util.toScreenToEdit(request.getParameter("docarchivedatefrom"),user.getLanguage());
    
    subscribeDateFrom = Util.toScreenToEdit(request.getParameter("subscribeDateFrom"),user.getLanguage());
    subscribeDateTo = Util.toScreenToEdit(request.getParameter("subscribeDateTo"),user.getLanguage());
    approveDateFrom = Util.toScreenToEdit(request.getParameter("approveDateFrom"),user.getLanguage());
    approveDateTo = Util.toScreenToEdit(request.getParameter("approveDateTo"),user.getLanguage());
    
    docarchivedateto = Util.toScreenToEdit(request.getParameter("docarchivedateto"),user.getLanguage());
    doccreatedatefrom = Util.toScreenToEdit(request.getParameter("doccreatedatefrom"),user.getLanguage());
    doccreatedateto = Util.toScreenToEdit(request.getParameter("doccreatedateto"),user.getLanguage());
    docapprovedatefrom = Util.toScreenToEdit(request.getParameter("docapprovedatefrom"),user.getLanguage());
    docapprovedateto = Util.toScreenToEdit(request.getParameter("docapprovedateto"),user.getLanguage());
    replaydoccountfrom = Util.toScreenToEdit(request.getParameter("replaydoccountfrom"),user.getLanguage());
    replaydoccountto = Util.toScreenToEdit(request.getParameter("replaydoccountto"),user.getLanguage());
    accessorycountfrom = Util.toScreenToEdit(request.getParameter("accessorycountfrom"),user.getLanguage());
    accessorycountto = Util.toScreenToEdit(request.getParameter("accessorycountto"),user.getLanguage());

    doclastmoduserid = Util.getIntValue(request.getParameter("doclastmoduserid"),0);
    docarchiveuserid = Util.getIntValue(request.getParameter("docarchiveuserid"),0);
    doccreaterid = Util.getIntValue(request.getParameter("doccreaterid"),0);
    doccreaterid2 = Util.getIntValue(request.getParameter("doccreaterid2"),0);

    docapproveuserid = Util.getIntValue(request.getParameter("docapproveuserid"),0);
    assetid = Util.getIntValue(request.getParameter("assetid"),0);
	usertype = Util.null2String(request.getParameter("usertype"));
	
	showtype = Util.getIntValue(request.getParameter("showtype"),0);
	treeDocFieldId =Util.null2String(request.getParameter("treeDocFieldId"));
	String docarchivedateselect = Util.null2String(request.getParameter("docarchivedateselect"));
String doclastmoddateselect = Util.null2String(request.getParameter("doclastmoddateselect"));
String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
if(urlType.equals("0")&&doccreatedateselect.equals("")){
	doccreatedateselect = "1";
}
String docapprovedateselect = Util.null2String(request.getParameter("docapprovedateselect"));
String approvedateselect = Util.null2String(request.getParameter("approvedateselect"));
String subscribedateselect = Util.null2String(request.getParameter("subscribedateselect"));
String currentState = Util.null2String(request.getParameter("currentState"));
String pop_state = Util.null2String(request.getParameter("pop_state"));
boolean isRanking = false;

String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
%>
  <wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(((isRanking)?20331:32905),user.getLanguage())%>'>
			<%if(mouldid==0||!(docsubject.equals(""))){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
				<wea:item>
					<input class=InputStyle type="text"  name="docsubject" id="docsubject" value="<%=docsubject%>">
				</wea:item>
			<%}%>
			<% if(urlType.equals("7") || urlType.equals("8") || urlType.equals("9")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></wea:item>
				<wea:item>
					 <SELECT NAME="currentState">
					  <OPTION value=""  <%if (currentState.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
					  <OPTION value="1" <%if (currentState.equals("1")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(18659,user.getLanguage())%></OPTION>
					  <OPTION value="2" <%if (currentState.equals("2")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(18660,user.getLanguage())%></OPTION>
					  <OPTION value="3" <%if (currentState.equals("3")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(18661,user.getLanguage())%></OPTION>  
				  </SELECT>
				</wea:item>
			<%}%>
			<%if(!urlType.equals("5")){ %>
				<%if(!(urlType.equals("7") || urlType.equals("8") || urlType.equals("9"))){ %>
					<%if(mouldid==0||doccreaterid!=0||doccreaterid2!=0){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
						<wea:item>
							<%if(!user.getLogintype().equals("2")){%>
							 <span style="float:left;">
									<select id="doccreateridsel" style="width:80px;" name="doccreaterididsel" onchange="changeType(this.value,'doccreaterid','doccreaterid2');">
										<option value="1" "<%=doccreaterid2==0?"selected":"" %>">
											<%=isgoveproj==0?SystemEnv.getHtmlLabelName(362,user.getLanguage()):SystemEnv.getHtmlLabelName(20098,user.getLanguage()) %>
										</option>
										<option value="2" "<%=doccreaterid2!=0?"selected":"" %>">
											<%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %>
										</option>
									</select>
								 </span>
							<%if(mouldid==0||doccreaterid != 0){%>
							  <span id="doccreateridselspan" style="<%=doccreaterid2==0?"":"display:none;" %>">
							   <brow:browser viewType="0" name="doccreaterid" browserValue='<%= ""+doccreaterid %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								_callback="afterShowResource"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
								browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(doccreaterid+""),user.getLanguage())%>'></brow:browser>
								</span>
									  
								<%}%>
						  <%}%>
						  <%if(isgoveproj==0){%>
					  
								<%if(mouldid==0||doccreaterid2 != 0){%>
			                      <span id="doccreaterid2selspan" style="<%=doccreaterid2!=0?"":"display:none;" %>">
										  <brow:browser viewType="0" name="doccreaterid2" browserValue='<%= ""+doccreaterid2 %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" _callback="afterShowParent"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=7" linkUrl="javascript:openhrm($id$)" width="150px"
								browserSpanValue='<%=doccreaterid2!=0?Util.toScreen(CustomerInfo.getCustomerInfoname(doccreaterid2+""),user.getLanguage()):""%>'></brow:browser>
									</span>
							  <%}%>
							  <%}%>
					  				<input type="hidden" name="usertype" value="<%=usertype%>">
						</wea:item>
					<%}%>
				<%} %>
			<%}else{ %>
				<%if((mouldid==0||!(docstatus.equals("")))){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
					<wea:item>
						<select class=InputStyle id="docstatus" name="docstatus">
							<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%if (docstatus.equals("1")||docstatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
							<option value="5" <%if (docstatus.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
							<option value="7" <%if (docstatus.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
					  </select>
					</wea:item>
				<%}%>
			<%} %>
			<%if(!urlType.equals("5")){ %>
				<%if(!(urlType.equals("7") || urlType.equals("8") || urlType.equals("9"))){ %>
					<%if(!user.getLogintype().equals("2")){%>
				     <%if(mouldid==0||departmentid!=0){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="departmentid" browserValue='<%= ""+departmentid %>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
										hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
										completeUrl="/data.jsp?type=4" 
										browserSpanValue='<%=departmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid+""),user.getLanguage()):""%>'>
								</brow:browser>
							</span>
						</wea:item>
				<%}}%>
				<%} %>
			<%}else{ %>
				<%if((mouldid==0||!(docno.equals("")))){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
					<wea:item><input class=InputStyle  type="text" name="docno" value='<%=docno%>'></wea:item>
				<%}%>
			<%} %>
			<%if(!user.getLogintype().equals("2") && (isRanking)){%>
				<%if(mouldid==0||creatersubcompanyid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="creatersubcompanyid" browserValue='<%= ""+creatersubcompanyid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=164" 
									browserSpanValue='<%=creatersubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(creatersubcompanyid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
				<%}%>
			<%}%>
			<%if(!(urlType.equals("7") || urlType.equals("8") || urlType.equals("9"))){ %>
			<%if(mouldid==0|| !doccreatedatefrom.equals("") || !doccreatedateto.equals("")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="doccreatedateselect">
					    <input class=wuiDateSel type="hidden" name="doccreatedatefrom" value="<%=doccreatedatefrom%>">
					    <input class=wuiDateSel  type="hidden" name="doccreatedateto" value="<%=doccreatedateto%>">
					</span>
				</wea:item>
			<%}%>
			<%} %>
			<%if((mouldid==0||treeDocFieldId!="")&& (isRanking)){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
                        <brow:browser viewType="0" name="treeDocFieldId" browserValue='<%= ""+treeDocFieldId %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="
					hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=-99999" 
					browserSpanValue='<%=!"".equals(treeDocFieldId)?DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(treeDocFieldId,","):""%>'>
					</brow:browser>
					</span>
				</wea:item>
			<%}%>
			<%if(isRanking){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></wea:item>
				<wea:item>
					<SELECT  class=InputStyle id="dspreply" name=dspreply>
					   <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					   <option value="1" <%if (dspreply.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18467,user.getLanguage())%></option>
					   <option value="2" <%if (dspreply.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18468,user.getLanguage())%></option>
					</SELECT>    
				</wea:item>
			<%} %>
			<% if(urlType.equals("7") || urlType.equals("8") || urlType.equals("9")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(18657,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="subscribedateselect">
					    <input class=wuiDateSel type="hidden" name="subscribeDateFrom" value="<%=subscribeDateFrom%>">
					    <input class=wuiDateSel  type="hidden" name="subscribeDateTo" value="<%=subscribeDateTo%>">
					</span>
				</wea:item>
			<%}%>
			<% if(urlType.equals("7")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(18658,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="approvedateselect">
					    <input class=wuiDateSel type="hidden" name="approveDateFrom" value="<%=approveDateFrom%>">
					    <input class=wuiDateSel  type="hidden" name="approveDateTo" value="<%=approveDateTo%>">
					</span>
				</wea:item>
			<%}else{%>
			<%} %>
		</wea:group>
		<%if(!(isRanking)){ %>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'>
			<%if((mouldid==0||!(docno.equals("")))&&!urlType.equals("5")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
				<wea:item><input class=InputStyle  type="text" name="docno" value='<%=docno%>'></wea:item>
			<%}%>
			<%if(urlType.equals("5")){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></wea:item>
				<wea:item>
					<SELECT  class=InputStyle id="dspreply" name=dspreply>
					   <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					   <option value="1" <%if (dspreply.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18467,user.getLanguage())%></option>
					   <option value="2" <%if (dspreply.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18468,user.getLanguage())%></option>
					</SELECT>    
				</wea:item>
			<%} %>
			<%if((mouldid==0||(containreply.equals("1"))) && !urlType.equals("7")  && !urlType.equals("8")  && !urlType.equals("9") && !urlType.equals("5")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></wea:item>
				<wea:item>
					<SELECT  class=InputStyle id="dspreply" name=dspreply>
					   <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					   <option value="1" <%if (dspreply.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18467,user.getLanguage())%></option>
					   <option value="2" <%if (dspreply.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18468,user.getLanguage())%></option>
					</SELECT>    
				</wea:item>
			<%}%>
			<%if(!user.getLogintype().equals("2")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(mouldid==0||ownerid != 0){%>
						<span style="float:left;">
							<select style="width:80px;" id="owneridsel" name="owneridsel" onchange="changeType(this.value,'ownerid','ownerid2');">
								<option value="1" "<%=ownerid2==0?"selected":"" %>">
									<%=isgoveproj==0?SystemEnv.getHtmlLabelName(362,user.getLanguage()):SystemEnv.getHtmlLabelName(20098,user.getLanguage()) %>
								</option>
								<option value="2" "<%=ownerid2!=0?"selected":"" %>">
									<%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %>
								</option>
							</select>
    					</span>
						<span id="owneridselspan" style="<%=ownerid2==0?"":"display:none;" %>">
						  <brow:browser viewType="0" name="owneridn" browserValue='<%= ""+ownerid %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					_callback="afterShowResource"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
					browserSpanValue='<%=ownerid!=0?Util.toScreen(ResourceComInfo.getResourcename(ownerid+""),user.getLanguage()):""%>'></brow:browser>
					    </span>
					<%}%>
					<%if(isgoveproj==0){%>
						<%if(mouldid==0||ownerid2 != 0){%>
							<span id="ownerid2selspan" style="<%=ownerid2!=0?"":"display:none;" %>"><brow:browser viewType="0" name="ownerid2" browserValue='<%= ""+ownerid2 %>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" _callback="afterShowParent"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
                completeUrl="/data.jsp?type=7" width="150px"
                browserSpanValue='<%=Util.toScreen(CustomerInfo.getCustomerInfoname(ownerid2+""),user.getLanguage())%>'></brow:browser>
					</span>
						<%}%>
					<%}%>
				</wea:item>
			<%}%>
			<%if(!user.getLogintype().equals("2")){%>
				<%if(mouldid==0||ownerdepartmentid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="ownerdepartmentid" browserValue='<%= ""+ownerdepartmentid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=4" 
									browserSpanValue='<%=ownerdepartmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(ownerdepartmentid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
				<%}%>
			<%}%>
			<%if(!user.getLogintype().equals("2")){%>
				<%if(mouldid==0||ownersubcompanyid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="ownersubcompanyid" browserValue='<%= ""+ownersubcompanyid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=164" 
									browserSpanValue='<%=ownersubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(ownersubcompanyid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
				<%}%>
			<%}%>
			<%if(!user.getLogintype().equals("2") && !urlType.equals("5")){%>
				<%if(mouldid==0||creatersubcompanyid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="creatersubcompanyid" browserValue='<%= ""+creatersubcompanyid %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=164" 
									browserSpanValue='<%=creatersubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(creatersubcompanyid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</span>
					</wea:item>
				<%}%>
			<%}%>
			<%if(mouldid==0||!(docpublishtype.equals("0"))){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=InputStyle  id="docpublishtype" size="1" name="docpublishtype">
                            <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
                            <option value="1" <%if (docpublishtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
                            <option value="2" <%if (docpublishtype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></option>
                            <option value="3" <%if (docpublishtype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></option>
                          </select>
				</wea:item>
			<%}%>
			<%if(mouldid==0|| !doclastmoddatefrom.equals("") || !doclastmoddateto.equals("")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="doclastmoddateselect">
					    <input class=wuiDateSel type="hidden" name="doclastmoddatefrom" value="<%=doclastmoddatefrom%>">
					    <input class=wuiDateSel  type="hidden" name="doclastmoddateto" value="<%=doclastmoddateto%>">
					</span>
					
				</wea:item>
			<%}%>
			<%if(mouldid==0|| !docarchivedatefrom.equals("") || !docarchivedateto.equals("")){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(3000,user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan" selectId="docarchivedateselect">
							<input class=wuiDateSel type="hidden" name="docarchivedatefrom" value="<%=docarchivedatefrom%>">
							<input class=wuiDateSel  type="hidden" name="docarchivedateto" value="<%=docarchivedateto%>">
						</span>
						
					</wea:item>
			<%}%>
			<%if(mouldid==0|| !docapprovedatefrom.equals("") || !docapprovedateto.equals("")){%>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(1425,user.getLanguage())%><input type="hidden" name="docapprovedatefrom" value="<%=docapprovedatefrom%>"><input type="hidden" name="docapprovedateto" value="<%=docapprovedateto%>">
				</wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="docapprovedateselect">
						<input class=wuiDateSel type="hidden" name="docapprovedatefrom" value="<%=docapprovedatefrom%>">
						<input class=wuiDateSel  type="hidden" name="docapprovedateto" value="<%=docapprovedateto%>">
					</span>
                          <input type="hidden" name="docapprovedatetonouse" value="<%=docapprovedateto%>">
				</wea:item>
			<%}%>
			<% if(urlType.equals("12")){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(21887,user.getLanguage())%></wea:item>
				<wea:item>
					<select name="pop_state">
						<option value=""></option>
						<option value="0" <%if("0".equals(pop_state)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21888,user.getLanguage())%></option>
						<option value="1" <%if("1".equals(pop_state)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21889,user.getLanguage())%></option>
						<option value="2" <%if("2".equals(pop_state)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21917,user.getLanguage())%></option>
					 </select>
				</wea:item>
			<%}%>
			
			<%if(mouldid==0||treeDocFieldId!=""){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
                        <brow:browser viewType="0" name="treeDocFieldId" browserValue='<%= ""+treeDocFieldId %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="
					hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=-99999" 
					browserSpanValue='<%=!"".equals(treeDocFieldId)?DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(treeDocFieldId,","):""%>'>
					</brow:browser>
					</span>
				</wea:item>
			<%}%>
			<%if(mouldid==0||!(keyword.equals(""))){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(2005,user.getLanguage())%></wea:item>
				<wea:item><input class=InputStyle  type="text" name="keyword" <%if(!(keyword.equals(""))){%>value='<%=keyword%>'<%}%>></wea:item>
			<%}%>
			<%if(mouldid==0 || !replaydoccountfrom.equals("") || !replaydoccountto.equals("") ){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(2001,user.getLanguage())%></wea:item>
				<wea:item>
					<input class=InputStyle style="width:39%!important;" type="text"  name="replaydoccountfrom" value="<%=replaydoccountfrom%>" size=8>
                          -
                          <input class=InputStyle style="width:39%!important;" type="text"  name="replaydoccountto" value="<%=replaydoccountto%>" size=9>
				</wea:item>
			<%}%>
			<%if(urlType.equals("7")){ %>
			<%if(mouldid==0||!(contentname.equals(""))){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(24764,user.getLanguage())%></wea:item>
				<wea:item><input class=InputStyle  type="text" name="contentname" <%if(!(contentname.equals(""))){%>value='<%=contentname%>'<%}%>></wea:item>
			<%}}%>
			<%if(date2duringTokens.length>0){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=inputstyle  size=1 id=date2during name=date2during>
						<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						<%
						for(int i=0;i<date2duringTokens.length;i++)
						{
							int tempdate2during = Util.getIntValue(date2duringTokens[i],0);
							if(tempdate2during>36||tempdate2during<1)
							{
								continue;
							}
						%>
						<!-- 最近个月 -->
						<option value="<%=tempdate2during %>" <%if (date2during==tempdate2during) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
						<%
						} 
						%>
						<!-- 全部 -->
								<option value="38" <%if (date2during==38) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					 </select>
				</wea:item>
			<%}%>
			<%if(!user.getLogintype().equals("2")){%>
				<%if(mouldid==0|| doclastmoduserid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(3002,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="doclastmoduserid" browserValue='<%= ""+doclastmoduserid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue='<%= doclastmoduserid!=0?Util.toScreen(ResourceComInfo.getResourcename(doclastmoduserid+""),user.getLanguage()):"" %>'></brow:browser>
						   <input type="hidden" id="maincategory" name="maincategory" value="<%=maincategory%>">
						   <input type="hidden" id="subcategory" name="subcategory" value="<%=subcategory%>">
						   <input type="hidden" id="seccategory" name="seccategory" value="<%=seccategory%>">
					</wea:item>
				 <%}%>
			<%}%>
			<%if((mouldid==0||!(docstatus.equals("")))&& !urlType.equals("5")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=InputStyle id="docstatus" name="docstatus">
						<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						<option value="1" <%if (docstatus.equals("1")||docstatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
						<option value="5" <%if (docstatus.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
						<option value="7" <%if (docstatus.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
				  </select>
				</wea:item>
			<%}%>
			<%if(!user.getLogintype().equals("2")){%>
				<%if(mouldid==0|| docarchiveuserid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(3003,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
						   <brow:browser viewType="0" name="docarchiveuserid" browserValue='<%= ""+docarchiveuserid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue='<%= docarchiveuserid!=0?Util.toScreen(ResourceComInfo.getResourcename(docarchiveuserid+""),user.getLanguage()):"" %>'></brow:browser>
						</span>
					</wea:item>
			 <%}%>
			<%}%>
			<%if(mouldid==0||doclangurage!=0){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
					 <brow:browser viewType="0" name="doclangurage" browserValue='<%= ""+doclangurage %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/systeminfo/language/LanguageBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=-99998" linkUrl="#" 
								browserSpanValue='<%=doclangurage!=0?Util.toScreen(LanguageComInfo.getLanguagename(doclangurage+""),user.getLanguage()):"" %>'></brow:browser>
				  </span>
				</wea:item>
			 <%}%>
			 <%if(isgoveproj==0){%>
			  <%if(mouldid==0||crmid!=0){
			  %>
					<wea:item><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
	                      <brow:browser viewType="0" name="crmid" browserValue='<%= ""+crmid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp?type=7"  
							browserSpanValue='<%=crmid!=0?Util.toScreen(CustomerInfo.getCustomerInfoname(crmid+""),user.getLanguage()):""%>'></brow:browser>
						</span>
					</wea:item>
			<%}%>
			<%}%>
			<%if(mouldid==0||assetid!=0){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
	                      <brow:browser viewType="0" name="assetid" browserValue='<%= ""+assetid %>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp"
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
                completeUrl="/data.jsp?type=23"  
                browserSpanValue='<%=assetid!=0?Util.toScreen(CapitalComInfo.getCapitalname(assetid+""),user.getLanguage()):""%>'></brow:browser>
					</span>
				</wea:item>
			<%}%>
			<%if(!user.getLogintype().equals("2")){%>
                <%if(mouldid==0||docapproveuserid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(3001,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
						  <brow:browser viewType="0" name="docapproveuserid" browserValue='<%= ""+docapproveuserid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue='<%=docapproveuserid!=0?Util.toScreen(ResourceComInfo.getResourcename(docapproveuserid+""),user.getLanguage()):""%>'></brow:browser>
						</span>
					</wea:item>
			<%}%>
			<%}%>
			<%if(mouldid==0||itemmaincategoryid!=0){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
					  <brow:browser viewType="0" name="itemmaincategoryid" browserValue='<%= ""+itemmaincategoryid %>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowserAll.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp?type=-99997" linkUrl="#" 
						browserSpanValue='<%=itemmaincategoryid!=0?Util.toScreen(AssetAssortmentComInfo.getAssortmentName(itemmaincategoryid+""),user.getLanguage()):""%>'></brow:browser>
					</span>
				</wea:item>
			<%}%>
			<%if(mouldid==0||hrmresid!=0){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
					  <brow:browser viewType="0" name="hrmresid" browserValue='<%= ""+hrmresid %>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
						browserSpanValue='<%=hrmresid!=0?Util.toScreen(ResourceComInfo.getResourcename(hrmresid+""),user.getLanguage()):""%>'></brow:browser>
					</span>
				</wea:item>
			<%}%>
			<%if(isgoveproj==0){%>
               <%if(mouldid==0||projectid!=0){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
						  <brow:browser viewType="0" name="projectid" browserValue='<%= ""+projectid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp?type=8" linkUrl="#" 
							browserSpanValue='<%=projectid!=0?Util.toScreen(ProjectInfo.getProjectInfoname(projectid+""),user.getLanguage()):""%>'></brow:browser>
						</span>
					</wea:item>
			   <%}%>
			<%}%>
		</wea:group>
		<%} %>
		<%if(!urlType.equals("13")&&!urlType.equals("14")){ %>
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();jQuery('#advancedSearch',parent.document).click();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		<%}%>
  </wea:layout>	
	
<%} %>


<script language=javascript>


//设置关键字
function setKeyword(source,target,formId){
	jQuery("input#"+target).val(jQuery("#"+source).val());
}


function changeType(val,span1,span2){
	if(val=="2"){
		jQuery("#"+span1).val("");
		jQuery("#"+span1+"span").html("");
		jQuery("#"+span2+"selspan").show();
		jQuery("#"+span1+"selspan").hide();
	}else{
		jQuery("#"+span2).val("");
		jQuery("#"+span2+"span").html("");
		jQuery("#"+span1+"selspan").show();
		jQuery("#"+span2+"selspan").hide();
	}
}

function onShowBrowser1(id,url,type1){
	if(type1==1){
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px");
		$GetEle("con"+id+"_valuespan").innerHTML=id1;
    	$GetEle("con"+id+"_value").value=id1;
     }else if(type1==2){
    	id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px");
 		$GetEle("con"+id+"_value1span").innerHTML=id1;
     	$GetEle("con"+id+"_value1").value=id1;
     }
}
function onShowBrowser(id,url){
	datas = window.showModalDialog(url+"?selectedids="+$GetEle("con"+id+"_value").value);
	if (datas) {
        if (datas.id!=""){
        	$GetEle("con"+id+"_valuespan").innerHTML=datas.name;
        	$GetEle("con"+id+"_value").value=datas.id;
        	$GetEle("con"+id+"_name").value=datas.name;
        }
		else{
			$GetEle("con"+id+"_valuespan").innerHTML="";
        	$GetEle("con"+id+"_value").value="";
        	$GetEle("con"+id+"_name").value="";
		}
	}
}
function onShowDepartment(id,url){
	datas = window.showModalDialog(url+"?selectedDepartmentIds="+$GetEle("con"+id+"_value").value);
	if (datas) {
        if (datas.id!=""){
            var shtml="";
            if(datas.name.indexOf(",")!=-1){
                 var namearray =datas.name.substr(1).split(",");
                 for(var i=0;i<namearray.length;i++){
                	 shtml +=namearray[i]+" ";
                 }
             $GetEle("con"+id+"_valuespan").innerHTML=shtml;
            }else{
			
			$GetEle("con"+id+"_valuespan").innerHTML=datas.name;
			}
        	$GetEle("con"+id+"_value").value=datas.id;
        	$GetEle("con"+id+"_name").value=datas.name;
        }
		else{
			$GetEle("con"+id+"_valuespan").innerHTML="";
        	$GetEle("con"+id+"_value").value="";
        	$GetEle("con"+id+"_name").value="";
		}
	}
}
function onShowResourceThisJsp(tdname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(datas){
        if( datas.id!= "" ){
			$GetEle(tdname).innerHTML= "<a href='javaScript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</a>";
			$GetEle(inputename).value=datas.id;
        }else{
        	$GetEle(tdname).innerHTML="";
        	$GetEle(inputename).value="";
		}
	}
}
function onShowDept(tdname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$GetEle(inputename).value);
	if (datas) {
        if (datas.id!=""){
        	$GetEle(tdname).innerHTML=datas.name;
        	$GetEle(inputename).value=datas.id;
        }
		else{
			$GetEle(tdname).innerHTML="";
			$GetEle(inputename).value="";
		}
	}
}
function changelevel(tmpindex) {  
    try { //如果只有一个数量的时候就会出现BUG
    	document.all("check_con")(tmpindex-1).checked = true
    } catch (ex)   {
      document.all("check_con").checked = true
    }
}

function changeCheckConType(type) {
	document.all("check_con_"+type).checked = true
}


function onShowBrowserCommon(id,url,type1){

		if(type1==162){
			tmpids = $GetEle("con"+id+"_value").value;
			url = url + "&beanids=" + tmpids;
			url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));

		}
		id1 = window.showModalDialog(url);

		if(id1){

				if(id1.id!=0 && id1.id!=""){

	               if (type1 == 162) {
				   		var ids = id1.id;
						var names =  id1.name;
						var descs =  id1.key3;
						shtml = ""
						ids = ids.substr(1);
						$GetEle("con"+id+"_value").value=ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							shtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						$GetEle("con"+id+"_valuespan").innerHTML=shtml;

						return;
	               }
				   if (type1 == 161) {
					   	var ids = id1.id;
					   	var names = id1.name;
						var descs =  id1.desc;
						$GetEle("con"+id+"_value").value=ids;
						shtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						$GetEle("con"+id+"_valuespan").innerHTML=shtml;
						return ;
				   }


				}else{
						$GetEle("con"+id+"_valuespan").innerHTML="";
						$GetEle("con"+id+"_value").value="";
						$GetEle("con"+id+"_name").value="";
				}

			}

}

</script>

<%
}
%>




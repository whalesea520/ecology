
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page"/>
<jsp:useBean id="CustomDictManager" class="weaver.docs.docs.CustomDictManager" scope="page"/>
<jsp:useBean id="LabelUtil" class="weaver.proj.util.LabelUtil" scope="page"/>
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
int proTypeId = Util.getIntValue(request.getParameter("proTypeId"),0);//4projtype

String prjisuse = Util.null2String (request.getParameter("prjisuse"));//4projtype
String prjismand = Util.null2String (request.getParameter("prjismand"));//4projtype
int prjfieldorder = Util.getIntValue(request.getParameter("prjfieldorder"),0);//4projtype

String method = Util.null2String(request.getParameter("method"));
char flag=Util.getSeparator();
int userid=user.getUID();
MultiAclManager am = new MultiAclManager();
CategoryManager cm = new CategoryManager();

int secid = Util.getIntValue(request.getParameter("secCategoryId"),0);
int parentId = Util.getIntValue(SecCategoryComInfo.getParentId(""+secid));
boolean hasSecManageRight = false;
if(parentId>0){
	hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
}
if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !hasSecManageRight){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String isDialog = Util.null2String(request.getParameter("isdialog"));
String scope = Util.null2String(request.getParameter("scope"));
if(scope.equals(""))scope="DocCustomFieldBySecCategory";
if(method.equals("delete")){//删除自定义字段
	String delIds = Util.null2String(request.getParameter("ids"));
	CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",secid);
	List delFields = cfm.getFieldByPropId(delIds);
	cfm.deleteFields(delFields);
	String sql = "delete from DocSecCategoryDocProperty where "
		+ " secCategoryId = " + secid
		+ " and id in (" + delIds + ")";

	RecordSet.executeSql(sql);
	SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(secid);
	out.println("1");
	return;
}else if(method.equalsIgnoreCase("add") ){
	String fieldname = Util.null2String(request.getParameter("fieldname"));
	String fieldlabel = Util.null2String(request.getParameter("fieldlabel"));
	String fieldhtmltype = Util.null2String(request.getParameter("fieldhtmltype"));
	String type = Util.null2String(request.getParameter("type"));
	String flength = Util.null2String(request.getParameter("flength"));
	String definebroswerType = Util.null2String(request.getParameter("definebroswerType"));
	int weaverTableRows = Util.getIntValue(request.getParameter("weaverTableRows"),-1);
	FieldParam fp = new FieldParam();
	int err = 0;
	if(fieldhtmltype.equals("1")){
		fp.setSimpleText(Util.getIntValue(type,-1),flength);
	}else if(fieldhtmltype.equals("2")){
		fp.setText();
	}else if(fieldhtmltype.equals("3")){
		if(type.equals("161")||type.equals("162")){
			fp.setBrowser(Util.getIntValue(type,-1),definebroswerType);
		}else{
			fp.setBrowser(Util.getIntValue(type,-1));
		}
	}else if(fieldhtmltype.equals("4")){
		fp.setCheck();
	}else if(fieldhtmltype.equals("5")){
		fp.setSelect();
	}else{
		err = 1;
	}
	if(err==0){
		CustomDictManager.setScope(scope);
  		CustomDictManager.setClientAddress(request.getRemoteAddr());
  		CustomDictManager.setUser(user);
		int fieldid = CustomDictManager.addField(fp.getFielddbtype(),fieldhtmltype,type,fieldlabel,fieldname);
		if(fieldid!=-1){
			if(fieldhtmltype.equals("5")){
				for(int i=0,j=0;i<weaverTableRows;i++){
					String itemname = Util.null2String(request.getParameter("itemname_"+i));
					int docdefault = Util.getIntValue(request.getParameter("docdefault_"+i),0);
					int cancel = Util.getIntValue(request.getParameter("cancel_"+i),0);
					int fieldorder = Util.getIntValue(request.getParameter("fieldorder_"+i),-1);
					if(fieldorder==-1)fieldorder=j;
					if(itemname.equals(""))continue;
					String sql = "insert into cus_selectitem(fieldid,selectvalue,selectname,fieldorder,doc_isdefault,cancel) values("+
					fieldid+","+j+",'"+itemname+"',"+fieldorder+","+docdefault+","+cancel+")";
					RecordSet.executeSql(sql);
					j++;
				}
			}
			
			//4projtype
			if(proTypeId>0){
				
				int prjLabelid= LabelUtil.getLabelId(fieldlabel, user.getLanguage());
				String sql=""+
						" insert into cus_formfield "+
						" (scope, scopeid, fieldlable, fieldid, fieldorder,isuse, ismand,  prj_fieldlabel) "+
						" values "+
						" ('ProjCustomField','"+proTypeId+"','"+fieldlabel+"','"+fieldid+"','"+prjfieldorder+"','"+prjisuse+"','"+prjismand+"','"+prjLabelid+"') ";
				//System.out.println("sql1:\n"+sql);
				RecordSet.executeSql(sql);
				sql=" update cus_formdict set scope='ProjCustomField' where id='"+fieldid+"' ";
				RecordSet.executeSql(sql);
			}
			
		}
	}
	if("1".equals(isDialog)){
		response.sendRedirect("DocSecCategoryDocCustomProperties.jsp?err="+err+"&isclose=1");
		return;
	}
	response.sendRedirect("DocSecCategoryDocPropertiesEdit.jsp?id="+secid+"&tab=5");
	
}else if(method.equalsIgnoreCase("edit") ){
	int err = 0;
	String fieldname = Util.null2String(request.getParameter("fieldname"));
	String fieldlabel =Util.null2String(request.getParameter("fieldlabel"));
	String fieldhtmltype = Util.null2String(request.getParameter("fieldhtmltype"));
	String type = Util.null2String(request.getParameter("type"));
	String flength = Util.null2String(request.getParameter("flength"));
	String definebroswerType = Util.null2String(request.getParameter("definebroswerType"));
	int weaverTableRows = Util.getIntValue(request.getParameter("weaverTableRows"),-1);
	String canEdit = Util.null2String(request.getParameter("canEdit"));
	FieldParam fp = new FieldParam();
	String id = Util.null2String(request.getParameter("id"));
	String prjfieldlabel="";
	if(proTypeId>0){
		prjfieldlabel=fieldlabel;
		RecordSet.executeSql("select * from cus_formdict where id = "+id);
		if(RecordSet.next()){
			fieldlabel = Util.null2String(RecordSet.getString("fieldlabel"));
		}
		if(fieldlabel.equals(""))fieldlabel = "field"+id;
	}
	
	if(canEdit.equals("true")){
		if(fieldhtmltype.equals("1")){
			fp.setSimpleText(Util.getIntValue(type,-1),flength);
		}else if(fieldhtmltype.equals("2")){
			fp.setText();
		}else if(fieldhtmltype.equals("3")){
			if(type.equals("161")||type.equals("162")){
				fp.setBrowser(Util.getIntValue(type,-1),definebroswerType);
			}else{
				fp.setBrowser(Util.getIntValue(type,-1));
			}
		}else if(fieldhtmltype.equals("4")){
			fp.setCheck();
		}else if(fieldhtmltype.equals("5")){
			fp.setSelect();
		}else{
			err = 1;
		}
	}
	if(err==0){
		CustomDictManager.setScope(scope);
  		CustomDictManager.setClientAddress(request.getRemoteAddr());
  		CustomDictManager.setUser(user);
		int fieldid=-1;
		if(canEdit.equals("true")){
			fieldid = CustomDictManager.editField(fp.getFielddbtype(),fieldhtmltype,type,fieldlabel,fieldname,id,canEdit);
		}else{
			fieldid = CustomDictManager.editField(fieldlabel,id,canEdit);
		}
		if(fieldid!=-1){
			if(fieldhtmltype.equals("5")){
				try{
					rst.setAutoCommit(false);
					rst.executeSql("delete from cus_selectItem where fieldid="+id);
					int maxFieldOrder = 0;
					int maxSelectValue = 0;
					for(int i=0;i<weaverTableRows;i++){
						int selectvalue = Util.getIntValue(request.getParameter("selectvalue_"+i),-1);
						int fieldorder = Util.getIntValue(request.getParameter("fieldorder_"+i),-1);
						if(maxFieldOrder<fieldorder)maxFieldOrder = fieldorder;
						if(maxSelectValue<selectvalue)maxSelectValue = selectvalue;
					}
					for(int i=0;i<weaverTableRows;i++){
						String itemname = Util.null2String(request.getParameter("itemname_"+i));
						int docdefault = Util.getIntValue(request.getParameter("docdefault_"+i),0);
						int cancel = Util.getIntValue(request.getParameter("cancel_"+i),0);
						int selectvalue = Util.getIntValue(request.getParameter("selectvalue_"+i),-1);
						if(selectvalue==-1){
							selectvalue = maxSelectValue+1;
							maxSelectValue++;
						}
						int fieldorder = Util.getIntValue(request.getParameter("fieldorder_"+i),-1);
						if(fieldorder==-1){
							fieldorder = maxFieldOrder+1;
							maxFieldOrder++;
						}
						if(itemname.equals(""))continue;
						String sql = "insert into cus_selectitem(fieldid,selectvalue,selectname,fieldorder,doc_isdefault,cancel) values("+
						fieldid+","+selectvalue+",'"+itemname+"',"+fieldorder+","+docdefault+","+cancel+")";
						rst.executeSql(sql);
					}
					rst.commit();
				}catch(Exception e){
					rst.writeLog(e);
					rst.rollback();
				}
			}
		}
		
		//4projtype
		if(proTypeId>0){
			int prjLabelid= LabelUtil.getLabelId(prjfieldlabel, user.getLanguage());
			String sql=""+
					" update cus_formfield "+
					" set fieldorder='"+prjfieldorder+"',isuse='"+prjisuse+"', ismand='"+prjismand+"',  prj_fieldlabel='"+prjLabelid+"'  "+
					" where fieldid='"+fieldid+"' and scope='ProjCustomField' and scopeid='"+proTypeId+"' ";
			//System.out.println("sql2:\n"+sql);
			RecordSet.executeSql(sql);
		}
		
	}
	if("1".equals(isDialog)){
		response.sendRedirect("DocSecCategoryDocCustomPropertiesEdit.jsp?err="+err+"&isclose=1&id="+id);
		return;
	}
	response.sendRedirect("DocSecCategoryDocPropertiesEdit.jsp?id="+secid+"&tab=5");
}else if(method.equalsIgnoreCase("save") ){

    String[] fieldlable = request.getParameterValues("fieldlable");
    String[] fieldid = request.getParameterValues("fieldid");
    String[] fieldhtmltype = request.getParameterValues("fieldhtmltype");
    String[] type = request.getParameterValues("type");
    String[] flength = request.getParameterValues("flength");
    String[] ismand = request.getParameterValues("ismand");
    String[] selectitemid = request.getParameterValues("selectitemid");
    String[] selectitemvalue = request.getParameterValues("selectitemvalue");
    String[] definebroswerType = request.getParameterValues("definebroswerType");


    String[] settingPropertyId = request.getParameterValues("propertyid");
    String[] settingType = request.getParameterValues("stype");
    String[] settingLabelId = request.getParameterValues("labelId");
    String[] settingIsCustom = request.getParameterValues("isCustom");
    String[] settingScope = request.getParameterValues("scope");
    String[] settingScopeId = request.getParameterValues("scopeid");
    String[] settingFieldId = request.getParameterValues("fieldid1");
    String[] settingVisible = request.getParameterValues("visible");
    String[] settingCustomName = request.getParameterValues("customName");
    String[] settingColumnWidth = request.getParameterValues("columnWidth");
    String[] settingMustInput = request.getParameterValues("mustInput");
    
	for(int i=0;i<settingPropertyId.length;i++){
		int tmpId = Util.getIntValue(settingPropertyId[i],-1);
		int tmpSecCategoryId = secid;
		int tmpViewindex = i+1;
		int tmpType = Util.getIntValue(settingType[i],0);
		int tmpLabelId = Util.getIntValue(settingLabelId[i],-1);
		int tmpVisible = Util.getIntValue(settingVisible[i],1);
		String tmpCustomName = settingCustomName[i];
		//String tmpCustomName = new String(settingCustomName[i].getBytes("ISO-8859-1"),"GBK");
		int tmpColumnWidth = Util.getIntValue(settingColumnWidth[i],1);
		int tmpMustInput = Util.getIntValue(settingMustInput[i],1);
		int tmpIsCustom = Util.getIntValue(settingIsCustom[i],0);
		String tmpScope = settingScope[i];
		int tmpScopeId = Util.getIntValue(settingScopeId[i],-1);
		int tmpFieldId = Util.getIntValue(settingFieldId[i],-1);
		tmpCustomName=tmpCustomName.replaceAll("@"," ");
		if(tmpIsCustom==1){//自定义字段
			RecordSet.executeSql("update cus_formfield set ismand="+tmpMustInput+" where fieldid="+tmpFieldId+"  and scope='"+tmpScope+"' and scopeid="+tmpScopeId);
		}

    	if(tmpId==-1){
			RecordSet.executeSql("insert into DocSecCategoryDocProperty"
					+"(secCategoryId,viewindex,type,labelid,visible,customName,customNameEng,customNameTran,columnWidth,mustInput,isCustom,scope,scopeid,fieldid)"
					+"values("
					+tmpSecCategoryId+","
					+tmpViewindex+","
					+tmpType+","
					+tmpLabelId+","
					+tmpVisible+","
					+tmpColumnWidth+","
					+tmpMustInput+","
					+tmpIsCustom+","
					+"'"+tmpScope+"'"+","
					+tmpScopeId+","
					+tmpFieldId+")"
				);
    	} else {
			RecordSet.executeSql("update DocSecCategoryDocProperty"
					+" set secCategoryId = " + tmpSecCategoryId
					+" ,viewindex = " + tmpViewindex
					+" ,type = " + tmpType
					+" ,labelid = " + tmpLabelId
					+" ,visible = " + tmpVisible
					+" ,customName = " + "'" + tmpCustomName + "'"
					+" ,columnWidth = " + tmpColumnWidth
					+" ,mustInput = " + tmpMustInput
					+" ,isCustom = " + tmpIsCustom
					+" ,scope = " + "'"+tmpScope + "'"
					+" ,scopeid = " + tmpScopeId
					+" ,fieldid = " + tmpFieldId
					+" where id = " + tmpId
				);
    	}
	}
	
	String delFieldIds = "";

	
	
    SubCategoryComInfo.removeMainCategoryCache();
	SecCategoryComInfo.removeMainCategoryCache();
	
	
	SecCategoryDocPropertiesComInfo.removeCache();
	SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(secid);
	if("1".equals(isDialog)){
		response.sendRedirect("DocSecCategoryDocCustomProperties.jsp?isclose=1&id="+secid+"&tab=5");
		return;
	}
	response.sendRedirect("DocSecCategoryDocPropertiesEdit.jsp?id="+secid+"&tab=5");
}
%>
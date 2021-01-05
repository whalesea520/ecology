<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.hrm.definedfield.HrmFieldManager,
                 java.util.List,
                 weaver.docs.docs.FieldParam,
                 java.util.ArrayList,weaver.conn.RecordSetTrans"%>
<%@page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CptFieldManager" class="weaver.cpt.util.CptFieldManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<jsp:useBean id="HrmFieldComInfo" class="weaver.hrm.definedfield.HrmFieldComInfo" scope="page" />	
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<jsp:useBean id="CustomDictManager" class="weaver.docs.docs.CustomDictManager" scope="page" />
<%
    String method = Util.null2String(request.getParameter("method"));
    String formlabel = Util.null2String(request.getParameter("formlabel"));
    String viewtype = Util.null2String(request.getParameter("viewtype"));
    int scopeorder = Util.getIntValue(request.getParameter("scopeorder"),0);
    int parentid = Util.getIntValue(request.getParameter("parentid"),0);
    int id = Util.getIntValue(request.getParameter("id"),0);
    
    if(method.equals("addFieldTree")){
        id = CustomFieldTreeManager.addTreeField("HrmCustomFieldByInfoType", formlabel, viewtype, parentid, scopeorder);
        response.sendRedirect("AddHrmCustomTreeField.jsp?isclose=1&id="+id);
    }else if(method.equals("editFieldTree")){
        CustomFieldTreeManager.editTreeField(id, "HrmCustomFieldByInfoType", formlabel, viewtype, parentid, scopeorder);
        response.sendRedirect("EditHrmCustomTreeField.jsp?isclose=1&id="+id);
    }else if(method.equals("deleteFieldTree")){
        CustomFieldTreeManager.deleteTreeField(id, "HrmCustomFieldByInfoType");
        response.sendRedirect("EditHrmCustomTreeField.jsp?isclose=1&id="+id);
    }

    int scopeId = id;
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    HrmFieldManager hfm = new HrmFieldManager("HrmCustomFieldByInfoType",scopeId); 
    HrmDeptFieldManager hdfm = new HrmDeptFieldManager(4);
    if(method.equals("add")||method.equals("edit")){
        String[] fieldlable = request.getParameterValues("fieldlable");
        String[] fieldid = request.getParameterValues("fieldid");
        String[] fieldname = request.getParameterValues("fieldname");//字段名
        String[] fieldhtmltype = request.getParameterValues("fieldhtmltype");
        String[] type = request.getParameterValues("type");
        String[] flength = request.getParameterValues("flength");
        String[] groupid = request.getParameterValues("groupid");//分组id
        String[] isuse = request.getParameterValues("isuse");
        String[] ismand = request.getParameterValues("ismand");
        String[] isfixed = request.getParameterValues("isfixed");
        String[] filedOrder = request.getParameterValues("filedorder");
        String[] selectitemid = request.getParameterValues("selectitemid");
        String[] selectitemvalue = request.getParameterValues("selectitemvalue");
        String[] definebroswerType = request.getParameterValues("definebroswerType");
        
        //处理固定字段 无法新增 删除 只需要改变属性
        int selectIndex = 0;
        for(int i=0; fieldname!=null&&i<fieldname.length ; i++){
         fieldname[i] = Util.null2String(fieldname[i]);
         if(fieldname[i].length()==0 || !hfm.isBaseField(fieldname[i]))continue;
         hfm.checkField(fieldname[i], fieldlable[i] ,isuse[i],ismand[i],filedOrder[i], groupid[i]);
         if(hfm.isBaseDefinedField(fieldname[i])){
        	 //需要改名称
        	String labelname = fieldlable[i];
   				int lableid= 0;
  				boolean newlabel=false;
   				RecordSetTrans RecordSetTrans =new RecordSetTrans();
  				RecordSetTrans.setAutoCommit(false);
  				String mysql=""+
  						" select distinct t2.indexid from HtmlLabelInfo t2 where "+
  						" exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+labelname+"' and t1.languageid=7) "+
  						" and exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+labelname+"' and t1.languageid=8) "+ 
  						" and exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+labelname+"' and t1.languageid=9) " ;
  				RecordSetTrans.executeSql(mysql);
				  if(newlabel=(!RecordSetTrans.next())){
  				  	lableid = CptFieldManager.getNewIndexId(RecordSetTrans);
  					  RecordSetTrans.executeSql("delete from HtmlLabelIndex where id="+lableid);
  					  RecordSetTrans.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
  					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+labelname+"')");
  					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+labelname+"',7)");//中文
  					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+labelname+"',8)");//英文
  					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+labelname+"',9)");//繁体
  				  }else{
  				  	lableid=RecordSetTrans.getInt("indexid");
  				  }
  				  RecordSetTrans.commit();
  				  if(newlabel)LabelComInfo.addLabeInfoCache(""+lableid);//更新缓存
   					RecordSet.executeSql("update hrm_formfield set fieldlabel="+lableid+" where fieldname='"+fieldname[i]+"'");
         }
        }
        List delFields = cfm.getAllFields2();
        FieldParam fp = new FieldParam();
        int temId = 0;
        if(fieldlable!=null&&fieldid!=null&&fieldhtmltype!=null&&type!=null&&ismand!=null&&flength!=null){
            for(int i=0; i<fieldlable.length ; i++){
            		if(Util.null2String(fieldlable[i]).length()==0)continue;
            		fieldname[i] = Util.null2String(fieldname[i]);
            		if(fieldname[i].length()>0 && hfm.isBaseField(fieldname[i]))continue;//固定字段已在上面处理
                if(type[i].equals(""))type[i] = "0";
                delFields.remove(fieldid[i]);
                if(fieldhtmltype[i].equals("1")){
                    fp.setSimpleText(Util.getIntValue(type[i],-1),flength[i]);
                }else if(fieldhtmltype[i].equals("2")){
                    fp.setText();
                }else if(fieldhtmltype[i].equals("3")){
                    fp.setBrowser(Util.getIntValue(type[i],-1));
                }else if(fieldhtmltype[i].equals("4")){
                    fp.setCheck();
                }else if(fieldhtmltype[i].equals("5")){
                    fp.setSelect();
                }else if(fieldhtmltype[i].equals("6")){
                  	fp.setAttach();
              	}else{
                    continue;
                }
                if(Util.null2String(filedOrder[i]).length()==0)filedOrder[i]="0";
                String labelname = fieldlable[i];
        				int lableid = 0;		
        				boolean newlabel=false;
        				RecordSetTrans RecordSetTrans=new RecordSetTrans();
        				RecordSetTrans.setAutoCommit(false);
        				String mysql=""+
    						" select distinct t2.indexid from HtmlLabelInfo t2 where "+
    						" exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+labelname+"' and t1.languageid=7) "+
    						" and exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+labelname+"' and t1.languageid=8) "+ 
    						" and exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+labelname+"' and t1.languageid=9) " ;
    					 RecordSetTrans.executeSql(mysql);
    				  if(newlabel=(!RecordSetTrans.next())){
    				  	lableid = CptFieldManager.getNewIndexId(RecordSetTrans);
    					  RecordSetTrans.executeSql("delete from HtmlLabelIndex where id="+lableid);
    					  RecordSetTrans.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
    					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+labelname+"')");
    					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+labelname+"',7)");//中文
    					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+labelname+"',8)");//英文
    					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+labelname+"',9)");//繁体
    				  }else{
    				  	lableid=RecordSetTrans.getInt("indexid");
    				  }
    				  RecordSetTrans.commit();
    				  if(newlabel)LabelComInfo.addLabeInfoCache(""+lableid);//更新缓存
    				  
                if(groupid!=null){
                    if(("1").equals(isfixed[i]))
                        temId = CustomDictManager.addFixedField(fieldname[i], fp.getFielddbtype(), fieldhtmltype[i], type[i], ""+lableid, filedOrder[i], ismand[i], isuse[i], groupid[i],definebroswerType[i]);
                    else
                        temId = cfm.checkField(Util.getIntValue(fieldid[i]),""+lableid,fp.getFielddbtype(),fp.getFieldhtmltype(),type[i],isuse[i],ismand[i],filedOrder[i], groupid[i],definebroswerType[i]);
                }else{
                    if(("1").equals(isfixed[i]))
                        temId = CustomDictManager.addFixedField(fieldname[i], fp.getFielddbtype(), fieldhtmltype[i], type[i], ""+lableid, filedOrder[i], ismand[i], isuse[i], "0",definebroswerType[i]);
                    else
                        temId = cfm.checkField(Util.getIntValue(fieldid[i]),""+lableid,fp.getFielddbtype(),fp.getFieldhtmltype(),type[i],isuse[i],ismand[i],filedOrder[i],"0",definebroswerType[i]);
                }
                if("5".equals(fieldhtmltype[i])&&temId != -1){
                    ArrayList temItemValue = new ArrayList();
                    ArrayList temItemName = new ArrayList();
                    for(;selectitemid!=null && selectIndex<selectitemid.length;selectIndex++){
                        if("--".equals(selectitemid[selectIndex])){
                            selectIndex++;
                            break;
                        }
                        temItemValue.add(selectitemid[selectIndex]);
                        temItemName.add(selectitemvalue[selectIndex]);
                    }
                    
                    if(("1").equals(isfixed[i]))
                    hdfm.checkSelectField(temId, temItemValue, temItemName);
		    else
                    cfm.checkSelectField(temId, temItemValue, temItemName);
                }
            }
        }
        cfm.deleteFields(delFields);
        cfm.deleteColFields(delFields);
        HrmFieldManager.initHrmFieldLabel();
        HrmFieldComInfo.removeCache();
        if(temId>0)
            response.sendRedirect("EditHrmCustomField.jsp?id="+id+"&message=1");
        else
            response.sendRedirect("EditHrmCustomField.jsp?id="+id+"&message="+temId);
        return;
    }else if(method.equals("delete")){
        cfm.delete();
        HrmFieldComInfo.removeCache();
        if(parentid!=0){
            response.sendRedirect("EditHrmCustomField.jsp?id="+parentid);
            return;
        }else{
            response.sendRedirect("EditHrmCustomField.jsp?id="+id);
            return;
        }
    }



%>

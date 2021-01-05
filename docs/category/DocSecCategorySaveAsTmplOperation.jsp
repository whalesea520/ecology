
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
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String method = Util.null2String(request.getParameter("method"));
MultiAclManager am = new MultiAclManager();

char flag=Util.getSeparator();
int userid=user.getUID();
int secid = Util.getIntValue(request.getParameter("secCategoryId"),0);
int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
    if(isUseDocManageDetach){
      detachable=1;
    }
boolean hasSecManageRight = false;
	int parentId = Util.getIntValue(SecCategoryComInfo.getParentId(""+secid));
	
	if(parentId>0){
		hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	}
    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user) || hasSecManageRight) {
		canEdit = true ;
	}


int tmplId = Util.getIntValue(request.getParameter("tmplId"),0);

String isDialog = Util.null2String(request.getParameter("isdialog"));
String from = Util.null2String(request.getParameter("from"));
String fromSubId = Util.null2String(request.getParameter("fromSubId"));
String  subcompanyid="subcompanyid ";
if(detachable==1){
subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
}
if(method.equalsIgnoreCase("saveastmpl")){
    
    String tmplName = Util.null2String(request.getParameter("name"));
    String fromdir = Util.null2String(request.getParameter("fromdir"));  
    RecordSet.executeSql(" select count(0) from DocSecCategoryTemplate where name = '" + tmplName + "'");
    if(RecordSet.next()&&RecordSet.getInt(1)>0){
        response.sendRedirect("DocSecCategorySaveAsTmpl.jsp?id="+secid+"&msgid="+19995);
        return;
    }

    RecordSet.executeSql(
        " insert into DocSecCategoryTemplate( " +
        " name,subcategoryid,categoryname,docmouldid,publishable,replyable,shareable," +
		" cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2," +
		" croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum," +
		" hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject," +
		" projectlabel,hasfinance,financelabel,approveworkflowid,markable,markAnonymity,orderable," +
		" defaultLockedDoc,allownModiMShareL,allownModiMShareW,maxUploadFileSize,wordmouldid,coder," +
		" isSetShare,nodownload,norepeatedname,iscontroledbydir,puboperation,childdocreadremind," +
		" readoptercanprint,editionIsOpen,editionPrefix,readerCanViewHistoryEdition,isNotDelHisAtt,isOpenApproveWf," +
		" validityApproveWf,invalidityApproveWf,useCustomSearch,defaultdummycata " +
		" ,fromdir " +
		" ,appointedWorkflowId " +
		" ,isPrintControl " +
		" ,printApplyWorkflowId " +
		" ,relationable " +
		" ,maxOfficeDocFileSize " +
		" ,isOpenAttachment " +
		" ,isAutoExtendInfo " +
		" ,isLogControl " +
		" ,uploadext " +
		" ,logviewtype " +
		" ,pushOperation " +
		" ,pushways " +
		" ,subcompanyid " +
		" ) " +
		" ( select '" + tmplName + "'," +
		" subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype," +
		" cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1," +
		" crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset," +
		" assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel," +
		" hasfinance,financelabel,approveworkflowid,markable,markAnonymity,orderable,defaultLockedDoc," +
		" allownModiMShareL,allownModiMShareW,maxUploadFileSize,wordmouldid,coder,isSetShare,nodownload," +
		" norepeatedname,iscontroledbydir,puboperation,childdocreadremind,readoptercanprint,editionIsOpen," +
		" editionPrefix,readerCanViewHistoryEdition,isNotDelHisAtt,isOpenApproveWf,validityApproveWf,invalidityApproveWf,useCustomSearch,defaultdummycata" +
		" ," + fromdir +
		" ,appointedWorkflowId " + 
		" ,isPrintControl " +
		" ,printApplyWorkflowId " +
		" ,relationable " +
		" ,maxOfficeDocFileSize " +
		" ,isOpenAttachment " +
		" ,isAutoExtendInfo " +
		" ,isLogControl " +
		" ,uploadext " +
		" ,logviewtype " +
		" ,pushOperation " +
		" ,pushways " +
		" , " +subcompanyid+
		" from DocSecCategory where id = " + secid +
		" ) "
    );
    
    RecordSet.executeSql(" select max(id) from DocSecCategoryTemplate where name = '" + tmplName + "'");
    RecordSet.next();
    
    tmplId = Util.getIntValue(RecordSet.getString(1),0);
    if(tmplId>0){
        
        //创建/复制/移动文档权限
        RecordSet.executeSql(
            " insert into DirAccessControlList( " +
            " dirid,dirtype,seclevel,departmentid,roleid,rolelevel,usertype,permissiontype," +
            " operationcode,userid,subcompanyid,DocSecCategoryTemplateId,isolddate,seclevelmax ,includesub,jobdepartment, jobids, joblevel, jobsubcompany" +
            " ) " +
            " ( select " +
            " -1,-dirtype,seclevel,departmentid,roleid,rolelevel,usertype,permissiontype," +
            " operationcode,userid,subcompanyid," + tmplId +
			",isolddate,seclevelmax ,includesub,jobdepartment, jobids, joblevel, jobsubcompany from DirAccessControlList where dirid=" + secid + " and dirtype=2 " +
			" ) "
        );
        
        /*RecordSet.executeSql(
            " insert into DirAccessPermission( " +
            " dirid,dirtype,userid,usertype,createdoc,createdir,movedoc,copydoc,DocSecCategoryTemplateId " +
            " ) " +
            " ( select " +
            " -1,-dirtype,userid,usertype,createdoc,createdir,movedoc,copydoc," + tmplId +
   			" from DirAccessPermission where dirid=" + secid + " and dirtype=2 " +
   			" ) "
        );*/
        
        //与文档创建人相关的默认共享(内部/外部人员)
        RecordSet.executeSql(
                " insert into secCreaterDocPope( " +
                " secid,PCreater,PCreaterManager,PCreaterJmanager,PCreaterDownOwner,PCreaterSubComp," +
                " PCreaterDepart,PCreaterDownOwnerLS,PCreaterSubCompLS,PCreaterDepartLS,PCreaterW," +
                " PCreaterManagerW,PCreaterJmanagerW,PCreaterDL,PCreaterManagerDL,PCreaterSubCompDL,PCreaterDepartDL,PCreaterWDL,PCreaterManagerWDL,DocSecCategoryTemplateId " +
                " ) " +
                " ( select " +
                " -1,PCreater,PCreaterManager,PCreaterJmanager,PCreaterDownOwner,PCreaterSubComp," +
                " PCreaterDepart,PCreaterDownOwnerLS,PCreaterSubCompLS,PCreaterDepartLS,PCreaterW," +
                " PCreaterManagerW,PCreaterJmanagerW,PCreaterDL,PCreaterManagerDL,PCreaterSubCompDL,PCreaterDepartDL,PCreaterWDL,PCreaterManagerWDL," + tmplId +
    			" from secCreaterDocPope where secid = " + secid +
    			" ) "
        );
        
        //默认共享(与文档创建人无关)
        RecordSet.executeSql(
                " insert into DocSecCategoryShare( " +
                " seccategoryid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid," +
                " departmentid,roleid,foralluser,crmid,downloadlevel,DocSecCategoryTemplateId,orgGroupId,operategroup,orgid,includesub,custype,isolddate,seclevelmax,jobdepartment, jobids, joblevel, jobsubcompany" +
                " ) " +
                " ( select " +
                " -1,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid," +
                " departmentid,roleid,foralluser,crmid,downloadlevel," + tmplId +
    			",orgGroupId,operategroup,orgid,includesub,custype,isolddate,seclevelmax,jobdepartment, jobids, joblevel, jobsubcompany from DocSecCategoryShare where seccategoryid = " + secid +
    			" ) "
        );
        
        //文档编码
        RecordSet.executeSql(" select id from codemain where secCategoryId = " + secid);
        while(RecordSet.next()){
            int tmpId = Util.getIntValue(RecordSet.getString(1),0);
            if(tmpId > 0){
                RecordSet1.executeSql(
	                    " insert into codemain( " +
	                    " titleImg,titleName,isUse,allowStr,secDocCodeAlone,secCategorySeqAlone," +
	                    " dateSeqAlone,dateSeqSelect,secCategoryId,DocSecCategoryTemplateId" +
	                    " ) " +
	                    " ( select " +
	                    " titleImg,titleName,isUse,allowStr,secDocCodeAlone,secCategorySeqAlone," +
	                    " dateSeqAlone,dateSeqSelect,-1," + tmplId +
	        			" from codemain where id = " + tmpId +
	        			" ) "
	            );
	            RecordSet1.executeSql(" select max(id) from codemain where DocSecCategoryTemplateId = " + tmplId);
	            RecordSet1.next();
	            int targetId = Util.getIntValue(RecordSet1.getString(1),0);
	            if(targetId > 0){
	                RecordSet1.executeSql(
		                    " insert into codedetail( " +
		                    " codemainid,showname,showtype,value,codeorder,issecdoc " +
		                    " ) " +
		                    " ( select " + targetId + "," +
		                    " showname,showtype,value,codeorder,issecdoc" +
		        			" from codedetail where codemainid = " + tmpId +
		        			" ) "
		            );
	            }
	        }
        }
        
        //自定义字段
        List newCusFieldId = new ArrayList();
        List oldCusFiledId = new ArrayList();
        
        CustomFieldManager targetCfm = new CustomFieldManager("DocCustomFieldBySecCategoryTemplate",tmplId);
        List delFields = targetCfm.getAllFields2();
        FieldParam fp = new FieldParam();

        CustomFieldManager sourceCfm = new CustomFieldManager("DocCustomFieldBySecCategory",secid);
        sourceCfm.getCustomFields();
        while(sourceCfm.next()){
        	int i = 0;
            int tmpType = sourceCfm.getType();
            int tmpFieldId = sourceCfm.getId();
            int tmpHtmlType = Util.getIntValue(sourceCfm.getHtmlType());
            int tmpStrLength = Util.getIntValue(sourceCfm.getStrLength());
            String tmpLable = sourceCfm.getLable();
            String tmpIsMand = (sourceCfm.isMand()?"1":"0");
            String tmpfielddbtype=Util.null2String(sourceCfm.getFieldDbType());
            
            oldCusFiledId.add(tmpFieldId+"");
            
            //if(delFields!=null&&delFields.size()>0) delFields.remove(delFields.indexOf(tmpFieldId+""));

            tmpFieldId = -1;
                
            if(tmpHtmlType==1){
                fp.setSimpleText(tmpType,tmpStrLength+"");
            }else if(tmpHtmlType==2){
                fp.setText();
            }else if(tmpHtmlType==3){
                //fp.setBrowser(tmpType);
                if(tmpType==161||tmpType==162){
					fp.setBrowser(tmpType,tmpfielddbtype);
                }else{
					fp.setBrowser(tmpType);
                }
            }else if(tmpHtmlType==4){
                fp.setCheck();
            }else if(tmpHtmlType==5){
                fp.setSelect();
            }else{
                continue;
            }
            
             int temId = -1;
            
            if(tmpHtmlType == 5 && temId != -1){
                ArrayList temItemValue = new ArrayList();
                ArrayList temItemName = new ArrayList();

                sourceCfm.getSelectItem(sourceCfm.getId());
            	while(sourceCfm.nextSelect()){
            	    String tmpSelectItemId = sourceCfm.getSelectValue();
            	    String tmpSelectItemValue = sourceCfm.getSelectName();
                    temItemValue.add(tmpSelectItemId);
                    temItemName.add(tmpSelectItemValue);
                }
            	//targetCfm.checkSelectField(temId, temItemValue, temItemName);
            }
                    
            newCusFieldId.add(temId+"");

            i++;
        }
       // targetCfm.deleteFields(delFields);
        RecordSet.executeSql("delete from cus_formfield where  scope='DocCustomFieldBySecCategoryTemplate' and scopeid= "+ tmplId);
        RecordSet.executeSql("insert into cus_formfield(scope, scopeid, fieldid,fieldlable,fieldorder,isuse,ismand, groupid, dmlUrl) select 'DocCustomFieldBySecCategoryTemplate', "+tmplId+", fieldid,fieldlable,fieldorder,isuse,ismand, groupid, dmlUrl from cus_formfield where scope='DocCustomFieldBySecCategory' and scopeid= "+ secid);
       
        //文档属性页
        ArrayList oldPropertyId = new ArrayList();
        ArrayList newPropertyId = new ArrayList();
        
        RecordSet.executeSql(" select id,isCustom,fieldid from DocSecCategoryDocProperty where secCategoryId = " + secid);
        while(RecordSet.next()){
            int tmpId = Util.getIntValue(RecordSet.getString(1),0);
            int isCustom = Util.getIntValue(RecordSet.getString(2),0);
            int oldFiledId = Util.getIntValue(RecordSet.getString(3),0);
            
            String newScope = "";
            int newScopeId = 0;
            int newFieldId = 0;
            
            if(tmpId > 0){
                
                oldPropertyId.add(tmpId+"");
                
                if(isCustom>0){
                    newScope = "DocCustomFieldBySecCategoryTemplate";
                    newScopeId = tmplId;
                    for(int j=0;j<oldCusFiledId.size();j++){
                        if(Util.getIntValue((String)oldCusFiledId.get(j))==oldFiledId){
                            newFieldId = Util.getIntValue((String)newCusFieldId.get(j));
                        }
                    }
                }
                RecordSet1.executeSql(
	                    " insert into DocSecCategoryDocProperty( " +
	                    " secCategoryId,viewindex,type,labelid,visible,customName,columnWidth,mustInput," +
	                    " isCustom,scope,scopeid,fieldid,DocSecCategoryTemplateId" +
	                    " ) " +
	                    " ( select " + -1 + "," +
	                    " viewindex,type,labelid,visible,customName,columnWidth,mustInput," +
	                    " " + isCustom + ",'" + newScope + "'," + newScopeId + ",fieldid," + tmplId +
	        			" from DocSecCategoryDocProperty where id = " + tmpId +
	        			" ) "
	            );
	            
	            RecordSet1.executeSql(" select max(id) from DocSecCategoryDocProperty where DocSecCategoryTemplateId = " + tmplId);
	            RecordSet1.next();
	            int newId = Util.getIntValue(RecordSet1.getString(1),0);
	            newPropertyId.add(newId+"");
            }
        }
        
        //模版设置
        RecordSet.executeSql(" select id from DocSecCategoryMould where secCategoryId = " + secid);
        while(RecordSet.next()){
            int tmpId = Util.getIntValue(RecordSet.getString(1),0);
            if(tmpId > 0){
                RecordSet1.executeSql(
	                    " insert into DocSecCategoryMould( " +
	                    " secCategoryId,mouldType,mouldId,isDefault,mouldBind,DocSecCategoryTemplateId " +
	                    " ) " +
	                    " ( select " +
	                    " -1,mouldType,mouldId,isDefault,mouldBind," + tmplId +
	        			" from DocSecCategoryMould where id = " + tmpId +
	        			" ) "
	            );
	            RecordSet1.executeSql(" select max(id) from DocSecCategoryMould where DocSecCategoryTemplateId = " + tmplId);
	            RecordSet1.next();
	            int targetId = Util.getIntValue(RecordSet1.getString(1),0);
	            if(targetId > 0){
	                
	                RecordSet1.executeSql(" select DocSecCategoryMouldId,DocSecCategoryDocPropertyId,bookMarkId from DocSecCategoryMouldBookMark where DocSecCategoryMouldId = " + tmpId);
	                while(RecordSet1.next()){
	                    int tmpDocSecCategoryMouldId = Util.getIntValue(RecordSet1.getString(1),0);
	                    int tmpDocSecCategoryDocPropertyId = Util.getIntValue(RecordSet1.getString(2),0);
	                    int tmpBookMarkId = Util.getIntValue(RecordSet1.getString(3),0);
	                    
	                    int newDocSecCategoryDocPropertyId = tmpDocSecCategoryDocPropertyId;
	                    
	                    if(tmpDocSecCategoryMouldId > 0){
	                        if(tmpDocSecCategoryDocPropertyId>0){
	                            for(int j=0;j<oldPropertyId.size();j++){
	                                if(Util.getIntValue((String)oldPropertyId.get(j))==tmpDocSecCategoryDocPropertyId){
	                                    newDocSecCategoryDocPropertyId = Util.getIntValue((String)newPropertyId.get(j));
	                                    break;
	                                }
	                            }
	                        }
	                        
	                        RecordSet2.executeSql(
	        	                    " insert into DocSecCategoryMouldBookMark( " +
	        	                    " DocSecCategoryMouldId,bookMarkId,DocSecCategoryDocPropertyId " +
	        	                    " ) " +
	        	                    " values(" + targetId + "," + tmpBookMarkId + "," + newDocSecCategoryDocPropertyId +
	        	        			" ) "
	        	            );
	                    }
	                }
	            }
	        }
        }
        
        //审批工作流详细设置
        RecordSet.executeSql(" select * from DocSecCategoryApproveWfDetail where secCategoryId = " + secid);
        while(RecordSet.next()){
            int tmpapproveType = Util.getIntValue(RecordSet.getString("approveType"));
            int tmpworkflowId = Util.getIntValue(RecordSet.getString("workflowId"));
            int tmpworkflowFieldId = Util.getIntValue(RecordSet.getString("workflowFieldId"));
            int tmpdocPropertyFieldId = Util.getIntValue(RecordSet.getString("docPropertyFieldId"));
            
            int tmpNewdocPropertyFieldId = tmpdocPropertyFieldId;
            if(tmpdocPropertyFieldId>0){
                for(int j=0;j<oldPropertyId.size();j++){
                    if(Util.getIntValue((String)oldPropertyId.get(j))==tmpdocPropertyFieldId){
                        tmpNewdocPropertyFieldId = Util.getIntValue((String)newPropertyId.get(j));
                        break;
                    }
                }
            }
            
            RecordSet2.executeSql(
            	" insert into DocSecCategoryApproveWfDetail(secCategoryId,approveType,workflowId,workflowFieldId,docPropertyFieldId,DocSecCategoryTemplateId) " +
                " values(" + -1 + "," + tmpapproveType + "," + tmpworkflowId + "," + tmpworkflowFieldId + "," + tmpNewdocPropertyFieldId + "," + tmplId + ") "
            );
        }
        
        //自定义列表
        SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(secid);
        RecordSet.executeSql(" select * from DocSecCategoryCusSearch where secCategoryId = " + secid);
        while(RecordSet.next()){
            int tmpOldDocPropertyId = Util.getIntValue(RecordSet.getString("docPropertyId"));
            int tmpViewIndex = Util.getIntValue(RecordSet.getString("viewindex"),0);
            int tmpVisible = Util.getIntValue(RecordSet.getString("visible"),0);
            
            int tmpNewDocPropertyId = tmpOldDocPropertyId;
            if(tmpOldDocPropertyId>0){
                for(int j=0;j<oldPropertyId.size();j++){
                    if(Util.getIntValue((String)oldPropertyId.get(j))==tmpOldDocPropertyId){
                        tmpNewDocPropertyId = Util.getIntValue((String)newPropertyId.get(j));
                        break;
                    }
                }
            }
            
            RecordSet2.executeSql(
            	" insert into DocSecCategoryCusSearch(secCategoryId,docPropertyId,viewindex,visible,DocSecCategoryTemplateId) " +
                " values(" + -1 + "," + tmpNewDocPropertyId + "," + tmpViewIndex + "," + tmpVisible + "," + tmplId + ") "
            );
        }
    }
	if(isDialog.equals("1")){
		if(from.equals("subedit")){
			response.sendRedirect("DocSecCategorySaveAsTmpl.jsp?from="+from+"&isclose=1&id="+fromSubId);
		}else{
			response.sendRedirect("DocSecCategorySaveAsTmpl.jsp?from="+from+"&isclose=1&id="+secid);
		}
	}else{
		response.sendRedirect("DocSecCategoryBaseInfoEdit.jsp?id="+secid);
	}
	
} else if(method.equalsIgnoreCase("getsettingfromtmpl")){
    
    String sql =
    		" select categoryname,docmouldid,publishable,replyable,shareable," +
    		" cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2," +
    		" croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum," +
    		" hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject," +
    		" projectlabel,hasfinance,financelabel,approveworkflowid,markable,markAnonymity,orderable," +
    		" defaultLockedDoc,allownModiMShareL,allownModiMShareW,maxUploadFileSize,wordmouldid,coder," +
    		" isSetShare,nodownload,norepeatedname,iscontroledbydir,puboperation,childdocreadremind," +
    		" readoptercanprint,editionIsOpen,editionPrefix,readerCanViewHistoryEdition,isOpenApproveWf," +
    		" validityApproveWf,invalidityApproveWf,useCustomSearch,appointedWorkflowId,defaultdummycata " +
    		" ,isPrintControl,printApplyWorkflowId,relationable,maxOfficeDocFileSize,isOpenAttachment,isAutoExtendInfo,isNotDelHisAtt,isLogControl,uploadext,logviewtype,pushOperation,pushways" +
    		" from DocSecCategoryTemplate where id = " + tmplId
    		;
    
   
    RecordSet.executeSql(sql);
    RecordSet.next();
    
    sql =
            " UPDATE DocSecCategory set " +
            //" categoryname = '" + RecordSet.getString(1) + "'," +
            " docmouldid = " + Util.getIntValue(RecordSet.getString(2),0) + "," +
            " publishable = '" + RecordSet.getString(3) + "'," +
            " replyable = '" + RecordSet.getString(4) + "'," +
            " shareable = '" + RecordSet.getString(5) + "'," +
            " cusertype = '" + RecordSet.getString(6) + "'," +
            " cuserseclevel = " + Util.getIntValue(RecordSet.getString(7),0) + "," +
            " cdepartmentid1 = " + Util.getIntValue(RecordSet.getString(8),0) + "," +
            " cdepseclevel1 = " + Util.getIntValue(RecordSet.getString(9),0) + "," +
            " cdepartmentid2 = " + Util.getIntValue(RecordSet.getString(10),0) + "," +
            " cdepseclevel2 = " + Util.getIntValue(RecordSet.getString(11),0) + "," +
            " croleid1 = " + Util.getIntValue(RecordSet.getString(12),0) + "," +
            " crolelevel1 = '" + RecordSet.getString(13) + "'," +
            " croleid2 = " + Util.getIntValue(RecordSet.getString(14),0) + "," +
            " crolelevel2 = '" + RecordSet.getString(15) + "'," +
            " croleid3 = " + Util.getIntValue(RecordSet.getString(16),0) + "," +
            " crolelevel3 = '" + RecordSet.getString(17) + "'," +
            " hasaccessory = '" + RecordSet.getString(18) + "'," +
            " accessorynum = " + Util.getIntValue(RecordSet.getString(19),0) + "," +
            " hasasset = '" + RecordSet.getString(20) + "'," +
            " assetlabel = '" + RecordSet.getString(21) + "'," +
            " hasitems = '" + RecordSet.getString(22) + "'," +
            " itemlabel = '" + RecordSet.getString(23) + "'," +
            " hashrmres = '" + RecordSet.getString(24) + "'," +
            " hrmreslabel = '" + RecordSet.getString(25) + "'," +
            " hascrm = '" + RecordSet.getString(26) + "'," +
            " crmlabel = '" + RecordSet.getString(27) + "'," +
            " hasproject = '" + RecordSet.getString(28) + "'," +
            " projectlabel = '" + RecordSet.getString(29) + "'," +
            " hasfinance = '" + RecordSet.getString(30) + "'," +
            " financelabel = '" + RecordSet.getString(31) + "'," +
            " approveworkflowid = " + Util.getIntValue(RecordSet.getString(32),0) + "," +
            " markable = '" + RecordSet.getString(33) + "'," +
            " markAnonymity = '" + RecordSet.getString(34) + "'," +
            " orderable = '" + RecordSet.getString(35) + "'," +
            " defaultLockedDoc = " + Util.getIntValue(RecordSet.getString(36),0) + "," +
            " allownModiMShareL = " + Util.getIntValue(RecordSet.getString(37),0) + "," +
            " allownModiMShareW = " + Util.getIntValue(RecordSet.getString(38),0) + "," +
            " maxUploadFileSize = " + Util.getIntValue(RecordSet.getString(39),0) + "," +
            " wordmouldid = " + Util.getIntValue(RecordSet.getString(40),0) + "," +
            " coder = '" + RecordSet.getString(41) + "'," +
            " isSetShare = " + Util.getIntValue(RecordSet.getString(42),0) + "," +
            " nodownload = " + Util.getIntValue(RecordSet.getString(43),0) + "," +
            " norepeatedname = " + Util.getIntValue(RecordSet.getString(44),0) + "," +
            " iscontroledbydir = " + Util.getIntValue(RecordSet.getString(45),0) + "," +
            " puboperation = " + Util.getIntValue(RecordSet.getString(46),0) + "," +
            " childdocreadremind = " + Util.getIntValue(RecordSet.getString(47),0) + "," +
            " readoptercanprint = " + Util.getIntValue(RecordSet.getString(48),0) + "," +
            " editionIsOpen = " + Util.getIntValue(RecordSet.getString(49),0) + "," +
            " editionPrefix = '" + RecordSet.getString(50) + "'," +
            " readerCanViewHistoryEdition = " + Util.getIntValue(RecordSet.getString(51),0) + "," +
            " isOpenApproveWf = '" + RecordSet.getString(52) + "'," +
            " validityApproveWf = " + Util.getIntValue(RecordSet.getString(53),0) + "," +
            " invalidityApproveWf = " + Util.getIntValue(RecordSet.getString(54),0) + "," +
            " useCustomSearch = " + Util.getIntValue(RecordSet.getString(55),0) + "," +
            " appliedTemplateId = " + tmplId +
            " ,appointedWorkflowId = " + Util.getIntValue(RecordSet.getString(56),0) +"," +
            " defaultdummycata = '" + Util.null2String(RecordSet.getString(57)) + "'" +
            " ,isPrintControl = '" + Util.null2String(RecordSet.getString(58)) + "'" +
            " ,printApplyWorkflowId = " + Util.getIntValue(RecordSet.getString(59),0) +
            " ,relationable = " + Util.getIntValue(RecordSet.getString(60),0) +
            " ,maxOfficeDocFileSize = " + Util.getIntValue(RecordSet.getString(61),0) +
            " ,isOpenAttachment = " + Util.getIntValue(RecordSet.getString(62),0) +
            " ,isAutoExtendInfo = " + Util.getIntValue(RecordSet.getString(63),0) +
             " ,isNotDelHisAtt = " + Util.getIntValue(RecordSet.getString(64),0) +
             " ,isLogControl = '" + Util.null2String(RecordSet.getString(65)) +"'"+
             " ,uploadext = '" + Util.null2String(RecordSet.getString(66)) +"'"+
             " ,logviewtype = " + Util.getIntValue(RecordSet.getString(67),0) +
	     " ,pushOperation = " + Util.getIntValue(RecordSet.getString(68),0) +
	     	 " ,pushways = '" + Util.null2String(RecordSet.getString(69)) +"'"+
    		" where id = " + secid
    		;
    RecordSet1.executeSql(sql);

    
    //创建/复制/移动文档权限
    RecordSet.executeSql(
            " delete from DirAccessControlList where dirid=" + secid + " and dirtype=2 "
    );
    RecordSet.executeSql(
            " insert into DirAccessControlList( " +
            " dirid,dirtype,seclevel,departmentid,roleid,rolelevel,usertype,permissiontype," +
            " operationcode,userid,subcompanyid,DocSecCategoryTemplateId,isolddate,seclevelmax ,includesub,jobdepartment, jobids, joblevel, jobsubcompany " +
            " ) " +
            " ( select " + secid + "," +
            " -dirtype,seclevel,departmentid,roleid,rolelevel,usertype,permissiontype," +
            " operationcode,userid,subcompanyid,0" +
    		" ,isolddate,seclevelmax,includesub,jobdepartment, jobids, joblevel, jobsubcompany  from DirAccessControlList where DocSecCategoryTemplateId=" + tmplId +
    		" ) "
    );
    /*RecordSet.executeSql(
            " delete from DirAccessPermission where dirid=" + secid + " and dirtype=2 "
    );
    RecordSet.executeSql(
            " insert into DirAccessPermission( " +
            " dirid,dirtype,userid,usertype,createdoc,createdir,movedoc,copydoc,DocSecCategoryTemplateId " +
            " ) " +
            " ( select " + secid + "," +
            " -dirtype,userid,usertype,createdoc,createdir,movedoc,copydoc," +
            " 0 " +
    		" from DirAccessPermission where DocSecCategoryTemplateId=" + tmplId +
    		" ) "
    );*/

    //与文档创建人相关的默认共享(内部/外部人员)
    RecordSet.executeSql(
            " delete from secCreaterDocPope where secid = " + secid
    );
    RecordSet.executeSql(
            " insert into secCreaterDocPope( " +
            " secid,PCreater,PCreaterManager,PCreaterJmanager,PCreaterDownOwner,PCreaterSubComp," +
            " PCreaterDepart,PCreaterDownOwnerLS,PCreaterSubCompLS,PCreaterDepartLS,PCreaterW," +
            " PCreaterManagerW,PCreaterJmanagerW,PCreaterDL,PCreaterManagerDL,PCreaterSubCompDL,PCreaterDepartDL,PCreaterWDL,PCreaterManagerWDL,DocSecCategoryTemplateId " +
            " ) " +
            " ( select " + secid + "," +
            " PCreater,PCreaterManager,PCreaterJmanager,PCreaterDownOwner,PCreaterSubComp," +
            " PCreaterDepart,PCreaterDownOwnerLS,PCreaterSubCompLS,PCreaterDepartLS,PCreaterW," +
            " PCreaterManagerW,PCreaterJmanagerW,PCreaterDL,PCreaterManagerDL,PCreaterSubCompDL,PCreaterDepartDL,PCreaterWDL,PCreaterManagerWDL,0" +
			" from secCreaterDocPope where DocSecCategoryTemplateId=" + tmplId +
			" ) "
    );
    
           
    //默认共享(与文档创建人无关)
    RecordSet.executeSql(
            " delete from DocSecCategoryShare where seccategoryid = " + secid
    );
    RecordSet.executeSql(
            " insert into DocSecCategoryShare( " +
            " seccategoryid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid," +
            " departmentid,roleid,foralluser,crmid,downloadlevel,DocSecCategoryTemplateId,orgGroupId,operategroup,orgid,includesub,custype,isolddate,seclevelmax,jobdepartment, jobids, joblevel, jobsubcompany" +
            " ) " +
            " ( select " + secid + "," +
            " sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid," +
            " departmentid,roleid,foralluser,crmid,downloadlevel,0" +
			" ,orgGroupId,operategroup,orgid,includesub,custype,isolddate,seclevelmax,jobdepartment, jobids, joblevel, jobsubcompany from DocSecCategoryShare where DocSecCategoryTemplateId=" + tmplId +
			" ) "
    );
           
    //文档编码
    RecordSet.executeSql(
            " delete from codedetail where codemainid in (select id from codemain where seccategoryid = " + secid + ")"
    );
    RecordSet.executeSql(
            " delete from codemain where seccategoryid = " + secid
    );
    RecordSet.executeSql(" select id from codemain where DocSecCategoryTemplateId=" + tmplId);
    while(RecordSet.next()){
        int tmpId = Util.getIntValue(RecordSet.getString(1),0);
        if(tmpId > 0){
            RecordSet1.executeSql(
                    " insert into codemain( " +
                    " titleImg,titleName,isUse,allowStr,secDocCodeAlone,secCategorySeqAlone," +
                    " dateSeqAlone,dateSeqSelect,secCategoryId,DocSecCategoryTemplateId" +
                    " ) " +
                    " ( select " +
                    " titleImg,titleName,isUse,allowStr,secDocCodeAlone,secCategorySeqAlone," +
                    " dateSeqAlone,dateSeqSelect," + secid + ",0" +
        			" from codemain where id = " + tmpId +
        			" ) "
            );
            RecordSet1.executeSql(" select max(id) from codemain where secCategoryId = " + secid);
            RecordSet1.next();
            int targetId = Util.getIntValue(RecordSet1.getString(1),0);
            if(targetId > 0){
                RecordSet1.executeSql(
	                    " insert into codedetail( " +
	                    " codemainid,showname,showtype,value,codeorder,issecdoc " +
	                    " ) " +
	                    " ( select " + targetId + "," +
	                    " showname,showtype,value,codeorder,issecdoc" +
	        			" from codedetail where codemainid = " + tmpId +
	        			" ) "
	            );
            }
        }
    }
           
    //自定义字段
    List newCusFieldId = new ArrayList();
    List oldCusFiledId = new ArrayList();
    
    CustomFieldManager targetCfm = new CustomFieldManager("DocCustomFieldBySecCategory",secid);
    List delFields = targetCfm.getAllFields2();
    FieldParam fp = new FieldParam();

    CustomFieldManager sourceCfm = new CustomFieldManager("DocCustomFieldBySecCategoryTemplate",tmplId);
    sourceCfm.getCustomFields();
    while(sourceCfm.next()){
    	int i = 0;
        int tmpType = sourceCfm.getType();
        int tmpFieldId = sourceCfm.getId();
        int tmpHtmlType = Util.getIntValue(sourceCfm.getHtmlType());
        int tmpStrLength = Util.getIntValue(sourceCfm.getStrLength());
        String tmpLable = sourceCfm.getLable();
        String tmpIsMand = (sourceCfm.isMand()?"1":"0");
        String tmpfielddbtype=Util.null2String(sourceCfm.getFieldDbType());
		
        oldCusFiledId.add(tmpFieldId+"");
        
        //if(delFields!=null&&delFields.size()>0) delFields.remove(delFields.indexOf(tmpFieldId+""));
            
        tmpFieldId = -1;

        if(tmpHtmlType==1){
            fp.setSimpleText(tmpType,tmpStrLength+"");
        }else if(tmpHtmlType==2){
            fp.setText();
        }else if(tmpHtmlType==3){
            //fp.setBrowser(tmpType);
            if(tmpType==161||tmpType==162){
				fp.setBrowser(tmpType,tmpfielddbtype);
            }else{
				fp.setBrowser(tmpType);
            }
        }else if(tmpHtmlType==4){
            fp.setCheck();
        }else if(tmpHtmlType==5){
            fp.setSelect();
        }else{
            continue;
        }
        
        int temId = targetCfm.checkField(tmpFieldId,tmpLable,fp.getFielddbtype(),fp.getFieldhtmltype(),tmpType+"",tmpIsMand,i+"");
        
        if(tmpHtmlType == 5 && temId != -1){
            ArrayList temItemValue = new ArrayList();
            ArrayList temItemName = new ArrayList();

            sourceCfm.getSelectItem(sourceCfm.getId());
        	while(sourceCfm.nextSelect()){
        	    String tmpSelectItemId = sourceCfm.getSelectValue();
        	    String tmpSelectItemValue = sourceCfm.getSelectName();
                temItemValue.add(tmpSelectItemId);
                temItemName.add(tmpSelectItemValue);
            }
        	//targetCfm.checkSelectField(temId, temItemValue, temItemName);
        }
                
        newCusFieldId.add(temId+"");

        i++;
    }
   // targetCfm.deleteFields(delFields);
   RecordSet.executeSql("delete from cus_formfield where  scope='DocCustomFieldBySecCategory' and scopeid= "+ secid);
    RecordSet.executeSql("insert into cus_formfield(scope, scopeid, fieldid,fieldlable,fieldorder,isuse,ismand, groupid, dmlUrl) select 'DocCustomFieldBySecCategory', "+secid+", fieldid,fieldlable,fieldorder,isuse,ismand, groupid, dmlUrl from cus_formfield where scope='DocCustomFieldBySecCategoryTemplate' and scopeid= "+ tmplId);
           
           
    //文档属性页
    ArrayList oldPropertyId = new ArrayList();
    ArrayList newPropertyId = new ArrayList();
           
    RecordSet.executeSql(
            " delete from DocSecCategoryDocProperty where secCategoryId = " + secid
    );
    RecordSet.executeSql(" select id,isCustom,fieldid from DocSecCategoryDocProperty where DocSecCategoryTemplateId = " + tmplId);
    while(RecordSet.next()){
        int tmpId = Util.getIntValue(RecordSet.getString(1),0);
        int isCustom = Util.getIntValue(RecordSet.getString(2),0);
        int oldFiledId = Util.getIntValue(RecordSet.getString(3),0);
        
        String newScope = "";
        int newScopeId = 0;
        int newFieldId = 0;
        
        if(tmpId > 0){
            
            oldPropertyId.add(tmpId+"");
            
            if(isCustom>0){
                newScope = "DocCustomFieldBySecCategory";
                newScopeId = secid;
                for(int j=0;j<oldCusFiledId.size();j++){
                    if(Util.getIntValue((String)oldCusFiledId.get(j))==oldFiledId){
                        newFieldId = Util.getIntValue((String)newCusFieldId.get(j));
                    }
                }
            }
            RecordSet1.executeSql(
                    " insert into DocSecCategoryDocProperty( " +
                    " secCategoryId,viewindex,type,labelid,visible,customName,columnWidth,mustInput," +
                    " isCustom,scope,scopeid,fieldid,DocSecCategoryTemplateId" +
                    " ) " +
                    " ( select " + secid + "," +
                    " viewindex,type,labelid,visible,customName,columnWidth,mustInput," +
                    " " + isCustom + ",'" + newScope + "'," + newScopeId + ",fieldid," + 0 +
        			" from DocSecCategoryDocProperty where id = " + tmpId +
        			" ) "
            );
            
            RecordSet1.executeSql(" select max(id) from DocSecCategoryDocProperty where secCategoryId = " + secid);
            RecordSet1.next();
            int newId = Util.getIntValue(RecordSet1.getString(1),0);
            newPropertyId.add(newId+"");
        }
    }
           
    //模版设置
    RecordSet.executeSql(
            " delete from DocSecCategoryMouldBookMark where DocSecCategoryMouldId in (select id from DocSecCategoryMould where secCategoryId = " + secid + ")"
    );
    RecordSet.executeSql(
            " delete from DocSecCategoryMould where secCategoryId = " + secid
    );
    RecordSet.executeSql(" select id from DocSecCategoryMould where DocSecCategoryTemplateId = " + tmplId);
    while(RecordSet.next()){
        int tmpId = Util.getIntValue(RecordSet.getString(1),0);
        if(tmpId > 0){
            RecordSet1.executeSql(
                    " insert into DocSecCategoryMould( " +
                    " secCategoryId,mouldType,mouldId,isDefault,mouldBind,DocSecCategoryTemplateId " +
                    " ) " +
                    " ( select " + secid + "," +
                    " mouldType,mouldId,isDefault,mouldBind," + 0 +
        			" from DocSecCategoryMould where id = " + tmpId +
        			" ) "
            );
            RecordSet1.executeSql(" select max(id) from DocSecCategoryMould where secCategoryId = " + secid);
            RecordSet1.next();
            int targetId = Util.getIntValue(RecordSet1.getString(1),0);
            if(targetId > 0){
                
                RecordSet1.executeSql(" select DocSecCategoryMouldId,DocSecCategoryDocPropertyId,bookMarkId from DocSecCategoryMouldBookMark where DocSecCategoryMouldId = " + tmpId);
                while(RecordSet1.next()){
                    int tmpDocSecCategoryMouldId = Util.getIntValue(RecordSet1.getString(1),0);
                    int tmpDocSecCategoryDocPropertyId = Util.getIntValue(RecordSet1.getString(2),0);
                    int tmpBookMarkId = Util.getIntValue(RecordSet1.getString(3),0);
                    
                    int newDocSecCategoryDocPropertyId = tmpDocSecCategoryDocPropertyId;
                    
                    if(tmpDocSecCategoryMouldId > 0){
                        if(tmpDocSecCategoryDocPropertyId>0){
                            for(int j=0;j<oldPropertyId.size();j++){
                                if(Util.getIntValue((String)oldPropertyId.get(j))==tmpDocSecCategoryDocPropertyId){
                                    newDocSecCategoryDocPropertyId = Util.getIntValue((String)newPropertyId.get(j));
                                    break;
                                }
                            }
                        }
                        
                        RecordSet2.executeSql(
        	                    " insert into DocSecCategoryMouldBookMark( " +
        	                    " DocSecCategoryMouldId,bookMarkId,DocSecCategoryDocPropertyId " +
        	                    " ) " +
        	                    " values(" + targetId + "," + tmpBookMarkId + "," + newDocSecCategoryDocPropertyId + " ) "
        	            );
                    }
                }
            }
        }
    }
    
    //审批工作流详细设置
    RecordSet.executeSql(
        " delete from DocSecCategoryApproveWfDetail where secCategoryId=" + secid
    );
    
    RecordSet.executeSql(" select * from DocSecCategoryApproveWfDetail where DocSecCategoryTemplateId = " + tmplId);
    while(RecordSet.next()){
        int tmpapproveType = Util.getIntValue(RecordSet.getString("approveType"));
        int tmpworkflowId = Util.getIntValue(RecordSet.getString("workflowId"));
        int tmpworkflowFieldId = Util.getIntValue(RecordSet.getString("workflowFieldId"));
        int tmpdocPropertyFieldId = Util.getIntValue(RecordSet.getString("docPropertyFieldId"));
        
        int tmpNewdocPropertyFieldId = tmpdocPropertyFieldId;
        if(tmpdocPropertyFieldId>0){
            for(int j=0;j<oldPropertyId.size();j++){
                if(Util.getIntValue((String)oldPropertyId.get(j))==tmpdocPropertyFieldId){
                    tmpNewdocPropertyFieldId = Util.getIntValue((String)newPropertyId.get(j));
                    break;
                }
            }
        }
        
        RecordSet2.executeSql(
        	" insert into DocSecCategoryApproveWfDetail(secCategoryId,approveType,workflowId,workflowFieldId,docPropertyFieldId,DocSecCategoryTemplateId) " +
            " values(" + secid + "," + tmpapproveType + "," + tmpworkflowId + "," + tmpworkflowFieldId + "," + tmpNewdocPropertyFieldId + "," + 0 + ") "
        );
    }

    //自定义列表
    RecordSet.executeSql(
        " delete from DocSecCategoryCusSearch where secCategoryId=" + secid
    );
    
    RecordSet.executeSql(" select * from DocSecCategoryCusSearch where DocSecCategoryTemplateId = " + tmplId);
    while(RecordSet.next()){
        int tmpOldDocPropertyId = Util.getIntValue(RecordSet.getString("docPropertyId"));
        int tmpViewIndex = Util.getIntValue(RecordSet.getString("viewindex"),0);
        int tmpVisible = Util.getIntValue(RecordSet.getString("visible"),0);
        
        int tmpNewDocPropertyId = tmpOldDocPropertyId;
        if(tmpOldDocPropertyId>0){
            for(int j=0;j<oldPropertyId.size();j++){
                if(Util.getIntValue((String)oldPropertyId.get(j))==tmpOldDocPropertyId){
                    tmpNewDocPropertyId = Util.getIntValue((String)newPropertyId.get(j));
                    break;
                }
            }
        }
        
        RecordSet2.executeSql(
        	" insert into DocSecCategoryCusSearch(secCategoryId,docPropertyId,viewindex,visible,DocSecCategoryTemplateId) " +
            " values(" + secid + "," + tmpNewDocPropertyId + "," + tmpViewIndex + "," + tmpVisible + "," + 0 + ") "
        );
    }
    SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(secid);
    
    SecCategoryDocPropertiesComInfo.removeCache();
    SecCategoryCustomSearchComInfo.removeCache();
    
   	response.sendRedirect("DocSecCategoryBaseInfoEdit.jsp?id="+secid);
} else if(method.equalsIgnoreCase("deletetmpl")){
	String tempArr = Util.null2String(request.getParameter("tmplId"));
	String logsql = "";
	if(!tempArr.equals("")){
		RecordSet1.executeSql("select id,name from DocSecCategoryTemplate where id in ("+tempArr+")");
		String sql = "delete from DocSecCategoryTemplate where id in( " + tempArr+")";
		logsql = sql;
		RecordSet.executeSql(sql);
		sql = "delete from DirAccessControlList where DocSecCategoryTemplateId in( " + tempArr+")";
		logsql = logsql+";"+sql;
        RecordSet.executeSql(sql);
        //RecordSet.executeSql("delete from DirAccessPermission where DocSecCategoryTemplateId = " + tmplId);
		sql = "delete from secCreaterDocPope where DocSecCategoryTemplateId in( " + tempArr+")";
		logsql = logsql+";"+sql;
		RecordSet.executeSql(sql);
		sql = "delete from DocSecCategoryShare where DocSecCategoryTemplateId in( " + tempArr+")";
		logsql = logsql+";"+sql;
		RecordSet.executeSql(sql);
		sql = "delete from codedetail where codemainid in (select id from codemain where DocSecCategoryTemplateId in( " + tempArr+")" + ")";
		logsql = logsql+";"+sql;
		RecordSet.executeSql(sql);
		sql = "delete from codemain where DocSecCategoryTemplateId in( " + tempArr+")";
		logsql = logsql+";"+sql;
		RecordSet.executeSql(sql);
        sql = "delete from cus_formfield where scope='DocCustomFieldBySecCategoryTemplate' and scopeid in( " + tempArr+")";
        logsql = logsql+";"+sql;
        RecordSet.executeSql(sql);
		sql = "delete from DocSecCategoryDocProperty where DocSecCategoryTemplateId in( " + tempArr+")";
		logsql = logsql+";"+sql;
        RecordSet.executeSql(sql);
        sql = "delete from DocSecCategoryMouldBookMark where DocSecCategoryMouldId in (select id from DocSecCategoryMould where DocSecCategoryTemplateId in( " + tempArr+")" + ")";
        logsql = logsql+";"+sql;
		RecordSet.executeSql(sql);
		sql = "delete from DocSecCategoryMould where DocSecCategoryTemplateId in( " + tempArr+")";
		logsql = logsql+";"+sql;
        RecordSet.executeSql(sql);
        sql = "delete from DocSecCategoryApproveWfDetail where DocSecCategoryTemplateId in( " + tempArr+")";
        logsql = logsql+";"+sql;
        RecordSet.executeSql(sql);
        sql = "delete from DocSecCategoryCusSearch where DocSecCategoryTemplateId in( " + tempArr+")";
        logsql = logsql+";"+sql;
        RecordSet.executeSql(sql);
        while(RecordSet1.next()){
        	log.insSysLogInfo(user, RecordSet1.getInt(1), RecordSet1.getString(2), logsql, "272", "3", 0, request.getRemoteAddr());
        }
    }
    response.sendRedirect("/docs/category/DocSecCategoryTmplList.jsp");
}
%>
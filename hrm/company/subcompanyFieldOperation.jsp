<%@ page import="weaver.general.Util,
                 weaver.docs.docs.FieldParam,
                 java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="weaver.matrix.MatrixUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="HrmFieldComInfo" class="weaver.hrm.definedfield.HrmFieldComInfo" scope="page" />
<jsp:useBean id="CptFieldManager" class="weaver.cpt.util.CptFieldManager" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<%
	if(!HrmUserVarify.checkUserRight("SubCompanyDefineInfo1:SubMaintain1", user)){
		response.sendRedirect("/notice/noright.jsp");	
		return;
	}
    String method = Util.null2String(request.getParameter("method"));
    int scopeId = Util.getIntValue(request.getParameter("scopeId"),0);
    HrmDeptFieldManager hfm = new HrmDeptFieldManager(scopeId);
    if(method.equals("add")||method.equals("edit")){
        String[] fieldlabel = request.getParameterValues("fieldlabel");
        String[] fieldlabelid = request.getParameterValues("fieldlabelid");
        String[] fieldid = request.getParameterValues("fieldid");
        String[] fieldname = request.getParameterValues("fieldname");//字段名
        String[] fieldhtmltype = request.getParameterValues("fieldhtmltype");
        String[] type = request.getParameterValues("type");
        String[] flength = request.getParameterValues("flength");
        String[] groupid = request.getParameterValues("groupid");//分组id
        String[] isuse = request.getParameterValues("isuse");
        String[] ismand = request.getParameterValues("ismand");
        String[] isfixed = request.getParameterValues("isfixed");
        String[] filedorder = request.getParameterValues("filedorder");
        String[] selectitemid = request.getParameterValues("selectitemid");
        String[] selectitemvalue = request.getParameterValues("selectitemvalue");
        String[] definebroswerType = request.getParameterValues("definebroswerType");
        int temId = -1;
        int selectIndex = 0;
        for(int i=0; i<fieldid.length ; i++){
        	//需要改名称
        	String labelname = fieldlabel[i];
        	int lableid = 0;
        	if(Util.null2String(fieldlabelid[i]).length()==0){
  				boolean newlabel=false;
        	RecordSetTrans RecordSetTrans = new RecordSetTrans();
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
        	}else{
        		lableid = Util.getIntValue(fieldlabelid[i]);
        	}
  				  
	        if(Util.null2String(fieldid[i]).length()==0){
	        	FieldParam fp = new FieldParam();
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
	        	if("1".equals(isfixed[i])){
                    temId = hfm.addFixedField(fieldname[i], fp.getFielddbtype(), fieldhtmltype[i], type[i], ""+lableid, filedorder[i], ismand[i], isuse[i], groupid[i],definebroswerType[i]);
	        	}else{
                    temId = hfm.addField(fieldname[i], fp.getFielddbtype(), fieldhtmltype[i], type[i], ""+lableid, filedorder[i], ismand[i], isuse[i], groupid[i],definebroswerType[i]);
	        	}
	        }else{
	        	//只允许更改显示属性，数据库层面的不允许修改
	        	temId = Integer.parseInt(fieldid[i]);
	        	hfm.editField(fieldid[i], ""+lableid, filedorder[i], ismand[i], isuse[i], groupid[i],definebroswerType[i]);
	        }
          if(fieldhtmltype[i].equals("5")){
            ArrayList temItemValue = new ArrayList();
            ArrayList temItemName = new ArrayList();
            for(;selectIndex<selectitemid.length;selectIndex++){
                if(selectitemid[selectIndex].equals("--")){
                    selectIndex++;
                    break;
                }
                temItemValue.add(selectitemid[selectIndex]);
                temItemName.add(selectitemvalue[selectIndex]);
            }
            
            hfm.checkSelectField(temId, temItemValue, temItemName);
        	}
        }

        HrmFieldComInfo.removeFieldCache();

    	//同步分部数据到矩阵
        MatrixUtil.sysSubcompayData();
    	if(temId>0)
    	    response.sendRedirect("editSubcompanyFieldBatch.jsp?message=1");
    	else
            response.sendRedirect("editSubcompanyFieldBatch.jsp?message="+temId);
        return;
    }else if(method.equals("delete")){
      	String delfieldids = Util.null2String(request.getParameter("delfieldids"));
      	String[] fieldid = delfieldids.split(",");
      	for(int i=0;fieldid!=null&&i<fieldid.length;i++){
      		hfm.deleteFields(fieldid[i]);
      	}
      	out.print("1");

    	//同步分部数据到矩阵
        MatrixUtil.sysSubcompayData();
        //response.sendRedirect("editSubcompanyFieldBatch.jsp");
        //return;
    }
%>
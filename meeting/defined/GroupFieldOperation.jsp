<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.defined.MeetingWFComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.docs.docs.FieldParam"%>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%>
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<jsp:useBean id="LabelUtil" class="weaver.proj.util.LabelUtil" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="MeetingWFComInfo" class="weaver.meeting.defined.MeetingWFComInfo" scope="page" />
<%	
if(!HrmUserVarify.checkUserRight("Meeting:fieldDefined", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}

	int current_langId=7;
    String method = Util.null2String(request.getParameter("method"));
    int scopeId = Util.getIntValue(request.getParameter("scopeId"),1);
    MeetingFieldManager mfm = new MeetingFieldManager(scopeId);
    if(method.equals("add")||method.equals("edit")){
        String[] fieldlabel = request.getParameterValues("fieldlabel");
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
        String[] treebroswerType = request.getParameterValues("treebroswerType");
        //System.out.println("treebroswer="+treebroswer);
        int temId = -1;
        int selectIndex = 0;
        for(int i=0; i<fieldid.length ; i++){
	        if(Util.null2String(fieldid[i]).length()==0){
	        	//新增标签
	        	String labelname = fieldlabel[i];
   				int labelid= LabelUtil.getLabelId(labelname,current_langId);
   				
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
	        	temId = mfm.addField(fieldname[i], fp.getFielddbtype(), fieldhtmltype[i], type[i], ""+labelid, filedorder[i], ismand[i], isuse[i], groupid[i],scopeId,definebroswerType[i],treebroswerType[i],isfixed[i]);
	        }else{
	        	temId=Util.getIntValue(fieldid[i]);
	        	//只允许更改显示属性，数据库层面的不允许修改
	        	mfm.editField(fieldid[i],filedorder[i], ismand[i], isuse[i], groupid[i]);
	        }
          	if(fieldhtmltype[i].equals("5")){
          		int len=0;
          		if(null!=selectitemid){
          			len=selectitemid.length;
          		}
	            ArrayList temItemValue = new ArrayList();
	            ArrayList temItemName = new ArrayList();
	            for(;selectIndex<len;selectIndex++){
	                if(selectitemid[selectIndex].equals("--")){
	                    selectIndex++;
	                    break;
	                }
	                temItemValue.add(selectitemid[selectIndex]);
	                temItemName.add(selectitemvalue[selectIndex]);
	            }
	            mfm.checkSelectField(temId, temItemValue, temItemName);
        	}
        }

        MeetingFieldComInfo.removeFieldCache();
        MeetingWFComInfo.removeFieldCache();
        if(temId>=0)
            response.sendRedirect("GroupEditFieldBatch.jsp?scopeId="+scopeId+"&message=1");
        else
            response.sendRedirect("GroupEditFieldBatch.jsp?scopeId="+scopeId+"&message="+temId);
        return;
    }else if(method.equals("delete")){
      	String fieldids = request.getParameter("delfieldids");
      	if(!"".equals(fieldids)){
      		String[] fieldid=fieldids.split(",");
          	for(int i=0;fieldid!=null&&i<fieldid.length;i++){
          		if("".equals(fieldid[i])) continue;
          		mfm.deleteFields(fieldid[i]);
          	}
          	MeetingFieldComInfo.removeFieldCache();
          	MeetingWFComInfo.removeFieldCache();
      	}
        response.sendRedirect("GroupEditFieldBatch.jsp?scopeId="+scopeId);
        return;
    }
%>
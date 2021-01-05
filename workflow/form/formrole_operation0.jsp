<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="FieldManager" class="weaver.workflow.field.FieldManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    String src = Util.null2String(request.getParameter("src"));
    int formid = Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
    int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
    String createtype = Util.null2String(request.getParameter("createtype")) ;	

    ////得到标记信息
    if(src.equalsIgnoreCase("colcalrole")){
        String colcalstr = "";
        String maincalstr = "";
        String[] detailfield = request.getParameterValues("detailfield");
        
        String sumcols[]= null;
        if(detailfield!=null){
        	sumcols = new String[detailfield.length];
            for(int i=0; i<detailfield.length; i++){
                if(!detailfield[i].equals("")){
                	String sumcol=Util.null2String(request.getParameter("sumcol_"+detailfield[i]));
                	sumcols[i] = sumcol;
                	String mainfield=Util.null2String(request.getParameter("mainfield"+detailfield[i]));
                	//如果前台没有选择赋值给哪个主字段，则不保存赋值给主字段
                	if (!mainfield.isEmpty()) {
                	//if(!sumcol.equals("")){
                   		maincalstr += ";mainfield_"+mainfield+"=detailfield_"+detailfield[i];
                	//}
                	}
                }
            }
            if(!maincalstr.equals("")){
                maincalstr = maincalstr.substring(1);
            }
        }

        if(sumcols!=null){
            for(int i=0; i<sumcols.length; i++){
            	if(!sumcols[i].equals("")){
                	colcalstr += ";detailfield_"+detailfield[i];
            	}
            }
            if(!colcalstr.equals("")){
                colcalstr = colcalstr.substring(1);
            }
        }
        String sql = "select * from workflow_formdetailinfo where formid="+formid;
        RecordSet.executeSql(sql);
        if(RecordSet.next()){
            sql = "update workflow_formdetailinfo set colcalstr='"+colcalstr+"',maincalstr='"+maincalstr+"' where formid="+formid;
        }else{
            sql = "insert into workflow_formdetailinfo(formid,rowcalstr,colcalstr,maincalstr) values("+formid+",'','"+colcalstr+"','"+maincalstr+"')";
        }
        RecordSet.executeSql(sql);
        response.sendRedirect("/workflow/form/addformcolcal_new.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax="+ajax);
        return;
    }else if(src.equalsIgnoreCase("rowcalrole")){
        String[] calstr = request.getParameterValues("calstr");
        String rowcalstr = "";
        if(calstr != null){
            for(int i=0; i<calstr.length; i++){
                rowcalstr += ";"+calstr[i];
            }
            rowcalstr = rowcalstr.substring(1);
        }
        String sql = "select * from workflow_formdetailinfo where formid="+formid;
        RecordSet.executeSql(sql);
        if(RecordSet.next()){
            sql = "update workflow_formdetailinfo set rowcalstr='"+rowcalstr+"' where formid="+formid;
        }else{
            sql = "insert into workflow_formdetailinfo(formid,rowcalstr,colcalstr,maincalstr) values("+formid+",'"+rowcalstr+"','','')";
        }
        RecordSet.executeSql(sql);

        //if(createtype.equals("2")) {
            response.sendRedirect("/workflow/form/addformrowcal_new.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=1");
        //}
        // else {
        //     response.sendRedirect("/workflow/form/addformrowcal.jsp?formid="+formid+"&ajax="+ajax);
        // }
        
        return;
    }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">
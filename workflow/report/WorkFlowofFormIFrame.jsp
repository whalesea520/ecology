
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML>
<HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <%
  		String isBill = request.getParameter("isBill");
  	
	  	String formID = request.getParameter("formID");
	  	
	  	List workFlowIDList = new ArrayList();
	  	
	  	List workflowNameList = new ArrayList();
  	
	  	if(("0".equals(isBill) || "1".equals(isBill)) && (!"".equals(formID) && null != formID))
	  	{
	  	    RecordSet.execute("SELECT * FROM WorkFlow_Base WHERE formID = " + formID + " AND isBill = '" + isBill + "' AND isValid = '1'");
	  	
	  	    //System.out.println("SELECT * FROM WorkFlow_Base WHERE formID = " + formID + " AND isBill = '" + isBill + "' AND isValid = '1'");
	  	    
	  		while(RecordSet.next())
	  		{
	  		    workFlowIDList.add(RecordSet.getString("ID"));
	  		    workflowNameList.add(RecordSet.getString("workFlowName"));
	  		}
	  	}
  	  	  
    %>
</HEAD>

<BODY>

</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">

function init()
{	
<%
	int rowCount = (workFlowIDList.size() / 4 == workFlowIDList.size() / 4.0) ? workFlowIDList.size() / 4 : workFlowIDList.size() / 4 + 1;	

    for(int i = 0; i < rowCount; i++)
    {     
%>
        var oRow = parent.document.all("oTable").insertRow();
        var oCell;
        var oDiv;
        
<%
        for (int j = 0; j < 4; j++)
        //生成一行中的每一列
        {
			if(i * 4 + j < workFlowIDList.size())
			{
%>
				oCell = oRow.insertCell();
	            oDiv = parent.document.createElement("div");
            	oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='workflowID' value='" + <%= (String)workFlowIDList.get(i * 4 + j) %> + "'>";            
                oCell.appendChild(oDiv);
                
                oCell = oRow.insertCell();
	            oDiv = parent.document.createElement("div");
            	oDiv.innerHTML="<%= (String)workflowNameList.get(i * 4 + j) %>";            
                oCell.appendChild(oDiv);
<%
            }
            else
            {
%>
            	oCell = oRow.insertCell();
	            oDiv = parent.document.createElement("div");            
            	oDiv.innerHTML="";            	
            	oCell.appendChild(oDiv);
            	
            	oCell = oRow.insertCell();
	            oDiv = parent.document.createElement("div");            
            	oDiv.innerHTML="";            	
            	oCell.appendChild(oDiv);
<%
            }
        }          
    }
%>
}

function removeValue()
{
    var length = parent.document.all("oTable").rows.length;
    
    for (var i = length - 1; i >= 0; i--)
    {
        parent.document.all("oTable").deleteRow(i)
    }
}


removeValue();

init();

</SCRIPT>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="java.io.*" %>
<%
   String numLinesParam = request.getParameter("lines");
   String mode = request.getParameter("mode");
   int numLines = 0;
   String logDir = GCONST.getLogPath();
   String fileName = "ecology";
   File logFile = new File(logDir, fileName);
   //System.out.println(logFile.length());
   String lines[] = new String[0];
   int start = 0;
   try {
	    BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(logFile)));
	    String line;
	    int totalNumLines = 0;
	    while ((line=in.readLine()) != null) {
	        totalNumLines++;
	    }
	    in.close();
	    // adjust the 'numLines' var to match totalNumLines if 'all' was passed in:
	    if ("All".equals(numLinesParam)) {
	        numLines = totalNumLines;
	    }else{
	    	numLines = Integer.parseInt(numLinesParam);
	    }
	    lines = new String[numLines];
	    in = new BufferedReader(new InputStreamReader(new FileInputStream(logFile)));
	    // skip lines
	    start = totalNumLines - numLines;
	    if (start < 0) { start = 0; }
	    for (int i=0; i<start; i++) {
	        in.readLine();
	    }
	    int i = 0;
        while ((line=in.readLine()) != null && i<numLines) {
            lines[i] = line;
            i++;
        }
		response.setContentType("text/html;charset=UTF-8");   
		response.setHeader("Cache-Control","no-cache");
		PrintWriter out1 = response.getWriter();
	    for(int j=0;j<numLines;j++){
	    	out1.println(lines[j]);
	    }
		out1.close();
   } catch (FileNotFoundException ex) {
   	ex.printStackTrace();
   }
%>
var _SHAPE = [];
_SHAPE["roundrect"] = [];
_SHAPE["rect"] = [];
_SHAPE["oval"] = [];
_SHAPE["diamond"] = [];
_SHAPE["line"] = [];
_SHAPE["polyline"] = [];
_SHAPE["fillrect"] = [];
_SHAPE["selectbox"]=[];
_SHAPE["textbox"]=[];

_SHAPE["textbox"]['val']='<div id="{id}" style="position:absolute;left:{l};top:{t};width:{w};height:{h};z-index:{z};font-size=9pt">{text}</div>';

_SHAPE["selectbox"]["val"]=
				
				'<v:rect title="选择框" style="position:absolute;left:{l};top:{t};width:{w};height:{h};z-index:0" filled="false" strokecolor="#BEBEBE" strokeweight="1pt" id="selectbox">'+
					'<v:stroke dashstyle="dashdot"/>'+
				'</v:rect>';
				

_SHAPE["oval"]["demo"] = 
              '<v:Oval id="demoOval" title="圆形" style="position:relative;left:0px;top:0px;width:100px;height:40px;z-index:9" strokecolor="red" strokeweight="1">' +
                '<v:shadow id="demoOvalShadow" on="T" type="single" color="#b3b3b3" offset="5px,5px"/>' + 
                '<v:extrusion id="demoOvalExt" on="false" backdepth="20" />' +
                '<v:fill id="demoOvalFill" type="gradient" color="white" color2="white" />' +
                '<v:TextBox id="demoOvalText" inset="2pt,5pt,2pt,5pt" style="text-align:center; color:red; font-size:9pt;">示例</v:TextBox>' +
              '</v:Oval>';
_SHAPE["oval"]["val"] = 
			 
              '<v:rect pid ="{id}" id="{id}" stepId="{si}" style="display:{d};position:absolute;left:{l};top:{t};width:{w};height:{h};z-index:{z}"" strokecolor="{sc}" strokeweight="{sw}" fillcolor="{fc}" '+
              'onmouseout="" onmousemove="event.srcElement.style.cursor =\'move\'" onmousedown ="var Step = _FLOW.getStepByID(event.srcElement.stepId);_PointMoveID=event.srcElement.pid; objFocusedOn(event.srcElement.stepId);"'+
              ' ondblclick="var Step = _FLOW.getStepByID(event.srcElement.stepId); editStep(event.srcElement.stepId); Step.removePointByID(event.srcElement.pid); ">' +
              '</v:rect>';


_SHAPE["rect"]["demo"] = 
              '<v:rect id="demoRect" title="方形" style="z-index:0;position:relative;width:100px;height:40px;left:0px;top:0px;" strokecolor="blue" strokeweight="1">' +
              '  <v:shadow on="T" type="single" color="#b3b3b3" offset="5px,5px"/>' +
              '  <v:extrusion on="false" backdepth="20" />' +
              '  <v:fill type="gradient" color="white" color2="white" />' +
              '  <v:TextBox inset="2pt,5pt,2pt,5pt" style="text-align:center; color:blue; font-size:9pt;">示例</v:TextBox>' +
              '</v:rect>';
_SHAPE["rect"]["val"] =
              '<v:rect id="{id}" af="{af}" wt="{wt}" ist="{ist}" isc="{isc}" title="{title}" sc="{sc}" fsc="{fsc}" st="{st}" typ="Proc" style="z-index:{z};position:absolute;width:{w};height:{h};left:{l};top:{t};" strokecolor="#000" strokeweight="{sw}" ondblclick=\'editProc(this.id);\'>' +
              '  <v:fill type="gradient" color="#EDEDED" color2="#BFBCB1" />' +
              '  <v:TextBox id="{id}Text" inset="2pt,5pt,2pt,5pt" style="text-align:center; color:#000; font:12px Tahoma;">{text}</v:TextBox>' +
              '</v:rect>';
              
_SHAPE["fillrect"]["demo"] = 
              '<v:rect id="demoRect" title="填充方形" style="z-index:0;position:relative;width:100px;height:40px;left:0px;top:0px;" strokecolor="blue" strokeweight="1">' +
              '  <v:shadow on="T" type="single" color="#b3b3b3" offset="5px,5px"/>' +
              '  <v:extrusion on="false" backdepth="20" />' +
              '  <v:fill type="gradient" color="white" color2="white" />' +
              '  <v:TextBox inset="2pt,5pt,2pt,5pt" style="text-align:center; color:blue; font-size:9pt;">示例</v:TextBox>' +
              '</v:rect>';
_SHAPE["fillrect"]["val"] =
              '<v:rect id="{id}" af="{af}" wt="{wt}" ist="{ist}" isc="{isc}" title="{title}" sc="{sc}" fsc="{fsc}" st="{st}" typ="Proc" style="z-index:{z};position:absolute;width:{w};height:{h};left:{l};top:{t};" strokecolor="{sc}" strokeweight="{sw}" ondblclick=\'editProc(this.id);\'>' +
              '  <v:shadow on="{shadowenable}" type="single" color="{shadowcolor}" offset="5px,5px"/>' +
              '  <v:extrusion on="{3denable}" backdepth="{3ddepth}" />' +
              '  <v:fill type="frame" color="#CCCCCC" color2="#CCCCCC" />' +
              '  <v:TextBox id="{id}Text" inset="2pt,5pt,2pt,5pt" style="text-align:center; color:{tc}; font-size:{fs};">{text}</v:TextBox>' +
              '</v:rect>';
              
_SHAPE["roundrect"]["demo"] = 
              '<v:RoundRect id="demoRoundRect" title="圆角形" style="position:relative;left:0px;top:0px;width:100px;height:40px;z-index:9"" strokecolor="blue" strokeweight="1">' +
                '<v:shadow id="demoRoundRectShadow" on="T" type="single" color="#b3b3b3" offset="5px,5px"/>' + 
                '<v:extrusion id="demoRoundRectExt" on="false" backdepth="20" />' +
                '<v:fill id="demoRoundRectFill" type="gradient" color="white" color2="white" />' +
                '<v:TextBox id="demoRoundRectText" inset="2pt,5pt,2pt,5pt" style="text-align:center; color:#000; font:12px Tahoma;">示例</v:TextBox>' +
              '</v:RoundRect>';
_SHAPE["roundrect"]["val"] = 
              '<v:Rect id="{id}" af="{af}" text="{title}" wt="{wt}" ist="{ist}" isc="{isc}" title="{title}" sc="{sc}" fsc="{fsc}" st="{st}" typ="Proc" style="position:absolute;left:{l};top:{t};width:{w};height:{h};z-index:{z}"" strokecolor="#999" strokeweight="{sw}" arcsize="0.20" stroked = false '+
                'onmouseover=\'showFouces(this.id);\' onmousemove=\'showFouces(this.id);\'>' +
                '<v:fill type="gradient" color="#fff" color2="#eaeaea" angle="180" />' +
                '<v:imagedata src="/images/wfdesign/background_wev8.gif"/>'+
                '<v:TextBox id="{id}Text" inset="8pt,8pt,8pt,8pt" style="text-align:left;color:#444;font:14px tahoma;"><table><tr><td><img id="{id}Img"src="{img}" style="width:16px;height:16px;margin:0 4px 0px 0;"/></td><td><div style="font:12px">{text}</div></td></td></table></v:TextBox>' +
              '</v:Rect>';
              
_SHAPE["diamond"]["demo"] = 
              '<v:shape id="demoDiamond" title="菱形" type="#diamond" style="position:relative;left:0px;top:0px;width:100px;height:50px;z-index:9" strokecolor="blue" strokeweight="1">' +
                '<v:shadow on="T" type="single" color="#b3b3b3" offset="5px,5px"/>' +
                '<v:extrusion on="false" backdepth="20" />' +
                '<v:fill type="gradient" color="white" color2="white" />' +
                '<v:TextBox inset="5pt,10pt,5pt,5pt" style="text-align:center; color:blue; font-size:9pt;">示例</v:TextBox>' +
              '</v:shape>';
_SHAPE["diamond"]["val"] =
              '<v:shape type="#diamond" id="{id}" af="{af}" wt="{wt}" ist="{ist}" isc="{isc}" title="{title}" sc="{sc}" fsc="{fsc}" st="{st}" typ="Proc" style="position:absolute;width:{w};height:{h};left:{l};top:{t};z-index:{z}" strokecolor="{sc}" strokeweight="{sw}" ondblclick=\'editProc(this.id);\'>' +
              '  <v:shadow on="{shadowenable}" type="single" color="{shadowcolor}" offset="5px,5px"/>' +
              '  <v:extrusion on="{3denable}" backdepth="{3ddepth}" />' +
              '  <v:fill type="gradient" color="{sc1}" color2="{sc2}" />' +
              '  <v:TextBox id="{id}Text" inset="2pt,10pt,2pt,5pt" style="text-align:center; color:{tc}; font-size:{fs};">{text}</v:TextBox>' +
              '</v:shape>';

_SHAPE["line"]["demo"] = 
              '<v:line id="demoLine" title="直线" style="z-index:0;position:relative;" from="0,0" to="100,0" strokecolor="blue" strokeweight="1">' +
                '<v:stroke id="demoLineArrow" StartArrow="" EndArrow="Classic"/>' +
                '<v:TextBox inset="5pt,1pt,5pt,5pt" style="text-align:center; color:blue; font-size:9pt;"></v:TextBox>' +
              '</v:line>'
_SHAPE["line"]["val"] = 
              '<v:line id="{id}" title="{title}" sc="{sc}" fsc="{fsc}" typ="Step" style="z-index:{z};position:absolute;" {pt} strokecolor="{sc}" strokeweight="{sw}" onmousedown=\'objFocusedOn(this.id);\' ondblclick=\'editStep(this.id);\'>' +
                '<v:stroke id="{id}Arrow" StartArrow="{sa}" EndArrow="{ea}"/>' +
                '<v:TextBox id="{id}Text" inset="1pt,1pt,1pt,1pt" style="text-align:center; color:blue; font-size:9pt;">{cond}</v:TextBox>' +
              '</v:line>';
              
_SHAPE["polyline"]["demo"] = 
              '<v:PolyLine id="demoPolyLine" title="折线" filled="false" Points="0,20 50,0 100,20" style="z-index:0;position:relative;" strokecolor="blue" strokeweight="1">' +
                '<v:stroke id="demoPolyLineArrow" StartArrow="" EndArrow="Classic"/>' +
                '<v:TextBox inset="5pt,1pt,5pt,5pt" style="text-align:center; color:blue; font-size:9pt;"></v:TextBox>' +
              '</v:PolyLine>';
_SHAPE["polyline"]["val"] =
              '<v:PolyLine id="{id}" title="{title}" sc="{sc}" fsc="{fsc}" typ="Step" filled="false" Points="{pt}" style="z-index:{z};position:absolute;" strokecolor="#444" strokeweight="{sw}" onmouseout=""  onmousemove=" event.srcElement.style.cursor =\'hand\'; //showPoint(this.id);" onmousedown=\'objFocusedOn(this.id);\'>' + 
              '<v:stroke id="{id}Arrow" StartArrow="{sa}" EndArrow="{ea}"/>' + 
              '</v:PolyLine>';

function getShapeDemo(AName){
  return _SHAPE[AName.toLowerCase()]["demo"];
}

function getShapeVal(AName){
  return _SHAPE[AName.toLowerCase()]["val"];
}

function stuffShape(AStr, arr){
  var re = /\{(\w+)\}/g;
  return AStr.replace(re, function(a,b){return arr[b]}); 
}

document.write('<v:shapetype id="diamond" coordsize="12,12" path="m 6,0 l 0,6,6,12,12,6 x e"/>');

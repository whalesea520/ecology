$.extend({  
    z4x: function(s) {  
        var dom;  
        if (typeof(s) == "object") {  
            dom = s;  
        } else if (typeof(s) == "string") {  
            if (window.ActiveXObject) {  
                dom = new ActiveXObject("Microsoft.XmlDom");  
                dom.async = "false";  
                dom.loadXML(s);  
            } else {  
                dom = new DOMParser().parseFromString(s, "text/xml");  
            }  
        }  
        var _dig = function(ele) {  
            var oo = {};  
            var alen = (ele.attributes) ? ele.attributes.length: 0;  
            for (var i = 0; i < alen; i++) {  
                oo["$" + ele.attributes[i].name] = ele.attributes[i].value;  
            }  
  
            var elen = ele.childNodes.length;  
            if (elen == 0) return oo;  
  
            var tem;  
            for (var i = 0; i < elen; i++) {  
                tem = oo[ele.childNodes[i].nodeName];  
  
                if (typeof(tem) == "undefined") {  
  
                    if (ele.childNodes[i].childNodes.length == 0) {  
  
                        if (ele.childNodes[i].nodeName == "#text" || ele.childNodes[i].nodeName == "#cdata-section") {  
                            oo["$$"] = ele.childNodes[i].nodeValue;  
                        } else {  
                            oo[ele.childNodes[i].nodeName] = [_dig(ele.childNodes[i])];  
                        }  
  
                    } else {  
                        oo[ele.childNodes[i].nodeName] = [_dig(ele.childNodes[i])];  
                    }  
                } else {  
                    tem[tem.length] = _dig(ele.childNodes[i]);  
                    oo[ele.childNodes[i].nodeName] = tem;  
                }  
            }  
            return oo;  
        };  
  
        var oo = {};  
        oo[dom.documentElement.nodeName] = _dig(dom.documentElement);  
        return oo;  
    },  
    ref : function(o,sp)  
    {  
        sp = sp?sp:"\n";  
        var tem = [];  
        for(var i in o) tem[tem.length]=i+":"+o[i];  
        return tem.join(sp);  
    },
    toXml:function toXml(jsonCurNode,curXmlNode){
        if(jsonCurNode.task&&jsonCurNode.task.length>0){
            for(var i=0;i<jsonCurNode.task.length;i++){
                var newNode=document.createElement("task");
                $(newNode).attr("id"," "+jsonCurNode.task[i].$id+" ");
                curXmlNode.appendChild(newNode);
                if(jsonCurNode.task[i].task){
                    toXml(jsonCurNode.task[i],newNode);
                }
            }
        }
    }
});  
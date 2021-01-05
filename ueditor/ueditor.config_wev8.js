(function () {

    var URL = window.UEDITOR_HOME_URL || getUEBasePath();
    
    window.UEDITOR_CONFIG = {

        UEDITOR_HOME_URL: URL

        , serverUrl: URL + "jsp/controller.jsp"

        , toolbars: [[
            'fullscreen', 'source', '|',
            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 'insertorderedlist', 'insertunorderedlist',
            'lineheight',
            'indent','paragraph', '|',
            ,'justifyleft', 'justifycenter', 'justifyright', '|',
            'link', 'unlink', 'anchor', '|', 'imagenone', 'imageleft', 'imageright', 'imagecenter', '|',
            'insertimage', 'insertvideo', 'map', 'insertframe', 'background',
            'horizontal',  'spechars', '|',
            'inserttable' ,'|','cleardoc','removeformat', 'formatmatch','pasteplain', '|',
            'print', 'searchreplace', 'undo', 'redo','|','attachment'
        ]],
		docmoduletoolbars: [
             ['fullscreen', 'source', '|',
            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 'insertorderedlist', 'insertunorderedlist',
            'lineheight',
            'indent','paragraph', '|',
            ,'justifyleft', 'justifycenter', 'justifyright', '|',
            'link', 'unlink', 'anchor', '|', 'imagenone', 'imageleft', 'imageright', 'imagecenter', '|',
            'insertimage', 'insertvideo', 'map', 'insertframe', 'background',
            'horizontal',  'spechars', '|',
            'inserttable','|','cleardoc','removeformat', 'formatmatch','pasteplain', '|',
            'print', 'searchreplace', 'undo', 'redo']
        ],
        docreplytoolbars: [[
            'fullscreen', 'source', '|',
            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 'insertorderedlist', 'insertunorderedlist',
            'lineheight',
            'indent','paragraph', '|',
            ,'justifyleft', 'justifycenter', 'justifyright', '|',
            'link', 'unlink', 'anchor', '|', 'imagenone', 'imageleft', 'imageright', 'imagecenter', '|',
            'insertimage', 'insertvideo', 'map', 'insertframe', 'background',
            'horizontal',  'spechars', '|',
            'inserttable', '|','cleardoc','removeformat', 'formatmatch','pasteplain', '|',
            'print',  'searchreplace', 'undo', 'redo'
        ]],
        newstemplatetoolbars: [
             ['fullscreen', 'source', '|',
            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 'insertorderedlist', 'insertunorderedlist',
            'lineheight',
            'indent', '|',
            ,'justifyleft', 'justifycenter', 'justifyright', '|',
            'link', 'unlink', 'anchor', '|', 'imagenone', 'imageleft', 'imageright', 'imagecenter', '|',
            'insertimage', 'insertvideo',  'background',
            'horizontal',  'spechars', '|',
            'inserttable','|','cleardoc','removeformat', 'formatmatch','pasteplain', '|',
             'undo', 'redo']
        ],
		fileFieldName: "Filedata",
		imageFieldName: "Filedata",
		videoFieldName: "Filedata",
	    enableAutoSave: false,
		autoHeightEnabled:false,
		saveInterval: 500000000,
        remarkfontsize : 12,
        remarkfontfamily : "微软雅黑",
        disabledTableInTable:false
    };

    function getUEBasePath(docUrl, confUrl) {

        return getBasePath(docUrl || self.document.URL || self.location.href, confUrl || getConfigFilePath());

    }

    function getConfigFilePath() {

        var configPath = document.getElementsByTagName('script');

        return configPath[ configPath.length - 1 ].src;

    }

    function getBasePath(docUrl, confUrl) {

        var basePath = confUrl;


        if (/^(\/|\\\\)/.test(confUrl)) {

            basePath = /^.+?\w(\/|\\\\)/.exec(docUrl)[0] + confUrl.replace(/^(\/|\\\\)/, '');

        } else if (!/^[a-z]+:/i.test(confUrl)) {

            docUrl = docUrl.split("#")[0].split("?")[0].replace(/[^\\\/]+$/, '');

            basePath = docUrl + "" + confUrl;

        }

        return optimizationPath(basePath);

    }

    function optimizationPath(path) {

        var protocol = /^[a-z]+:\/\//.exec(path)[ 0 ],
            tmp = null,
            res = [];

        path = path.replace(protocol, "").split("?")[0].split("#")[0];

        path = path.replace(/\\/g, '/').split(/\//);

        path[ path.length - 1 ] = "";

        while (path.length) {

            if (( tmp = path.shift() ) === "..") {
                res.pop();
            } else if (tmp !== ".") {
                res.push(tmp);
            }

        }

        return protocol + res.join("/");

    }

    window.UE = {
        getUEBasePath: getUEBasePath
    };

})();

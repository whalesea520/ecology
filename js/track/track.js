var track = (function () {
    var start;
    var end;
    var duration = 0;
    start = new Date();
    var trackArrays = [];
    var trackUrl = "";
    var pageTrack = true;
    var open = true;

    function post(url, params) {
        var temp = document.createElement("form");
        temp.action = url;
        temp.method = "post";
        temp.style.display = "none";
        for (var x in params) {
            var opt = document.createElement("input");
            opt.name = x;
            opt.value = params[x];
            temp.appendChild(opt);
        }
        document.body.appendChild(temp);
        temp.submit();
        return temp;
    }

    $(".sTitle").live('click', function() {
        var trackContents = $(this).attr("esearch-val");
        var jsonTrack = eval('(' + trackContents + ')');

        jsonTrack.userAgent = navigator.userAgent;
        jsonTrack.type = "eventTrack";
        jsonTrack.timestamp = new Date().getTime();
        trackArrays.push(jsonTrack);

        if (trackArrays.length >= 200) {
            $.ajax({
                url: "AjaxSearchResult.jsp",
                type: "POST",
                data: {
                    "trackJson": JSON.stringify(trackArrays),
                    "action": "track"
                },
                success: function (result) {

                }
            });
            trackArrays = [];
        }
    });

    window.onunload = function (e) {
        end = new Date();
        duration = end.getTime() - start.getTime();
        duration = duration / 1000;

        if (pageTrack) {
            var trackVisit = {
                userAgent: navigator.userAgent,
                pageUrl: location.href,
                pageStayTime: duration,
                type: "pageTrack",
                timestamp: new Date().getTime()
            }

            trackArrays.push(trackVisit);
        }
        if (trackArrays.length > 0) {
            $.ajax({
                url: "AjaxSearchResult.jsp",
                type: "POST",
                data: {
                    "trackJson": JSON.stringify(trackArrays),
                    "action": "track"
                },
                success: function (result) {

                }
            });
        }

        trackArrays = [];
    }

    return {
        trackUrl: function (url) {
            trackUrl = url
        },
        pageTrack: function (track) {
            pageTrack = track
        },
        open: function (use) {
            open = use
        }
    };

})();
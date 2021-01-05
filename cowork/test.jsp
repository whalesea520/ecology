
<html>
<head>

<link href="/cowork/js/imgPopup/all.min.css" rel="stylesheet">
    
  <body class="">
    
  <script src="/cowork/js/imgPopup/zepto.min.js"></script>
  <script src="/cowork/js/imgPopup/jquery.magnific-popup.min.js"></script>

<div class="grid-c">
  <div class="example gc3">
    <div class="html-code grid-of-images">
      <a class="image-popup-vertical-fit" href="http://farm9.staticflickr.com/8241/8589392310_7b6127e243_b.jpg" title="Caption. Can be aligned it to any side and contain any HTML.">
        <img src="http://farm9.staticflickr.com/8241/8589392310_7b6127e243_s.jpg" width="75" height="75">
      </a>
      <a class="image-popup-fit-width" href="http://farm9.staticflickr.com/8379/8588290361_ecf8c27021_b.jpg" title="This image fits only horizontally.">
        <img src="http://farm9.staticflickr.com/8241/8588290361_ecf8c27021_s.jpg" width="75" height="75">
      </a>
      <a class="image-popup-no-margins" href="http://farm9.staticflickr.com/8241/9207329484_ba28755ec4_o.jpg">
        <img src="http://farm9.staticflickr.com/8241/9207329484_ba28755ec4_o.jpg" width="107" height="75">
      </a>
    </div>
    <script type="text/javascript">
      $(document).ready(function() {

        $('.image-popup-vertical-fit').magnificPopup({
          type: 'image',
          closeOnContentClick: true,
          mainClass: 'mfp-img-mobile',
          image: {
            verticalFit: true
          }
          
        });

        $('.image-popup-fit-width').magnificPopup({
          type: 'image',
          closeOnContentClick: true,
          image: {
            verticalFit: false
          }
        });

        $('.image-popup-no-margins').magnificPopup({
          type: 'image',
          closeOnContentClick: true,
          closeBtnInside: false,
          fixedContentPos: true,
          mainClass: 'mfp-no-margins mfp-with-zoom', // class to remove default margin from left and right side
          image: {
            verticalFit: true
          },
          zoom: {
            enabled: true,
            duration: 300 // don't foget to change the duration also in CSS
          }
        });

      });
    </script>
    <style type="text/css">
    /* padding-bottom and top for image */
    .mfp-no-margins img.mfp-img {
      padding: 0;
    }
    /* position of shadow behind the image */
    .mfp-no-margins .mfp-figure:after {
      top: 0;
      bottom: 0;
    }
    /* padding for main container */
    .mfp-no-margins .mfp-container {
      padding: 0;
    }
    </style>
  </div>

</body></html>
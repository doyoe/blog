<form class="site-search-form">
  <input class="menu-search-input" id="bdcsMain" type="text">
</form>
<script type="text/javascript">
(function () {
  document.write(unescape('%3Cdiv id="bdcs"%3E%3C/div%3E'));
  var bdcs = document.createElement('script');
  bdcs.type = 'text/javascript';
  bdcs.async = true;
  bdcs.src = 'http://znsv.baidu.com/customer_search/api/js?sid=13673782525430730397' +
    '&plate_url=' + encodeURIComponent(window.location.href) + '&t=' + Math.ceil(new Date() / 3600000);
  var s = document.getElementsByTagName('script')[0];
  s.parentNode
    .insertBefore(bdcs, s);
})();
</script>

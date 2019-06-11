// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
function getPosition() {
  navigator.geolocation.getCurrentPosition(
    function(position) {
      const radius = document.search.radius;
      const num = radius.selectedIndex;
      const range = radius.options[num].value;
      const word = document.getElementById("word").value;
      window.location.href = "/restaurants/search?latitude="+position.coords.latitude+"&longitude="+position.coords.longitude+"&range="+range+"&word="+word
    },
    function(error) {
      switch(error.code) {
        case 1:
          alert("位置情報の利用が許可されていません");
          break;
        case 2:
          alert("現在位置が取得できませんでした");
          break;
        case 3:
          alert("タイムアウトになりました");
          break;
        default:
          alert("その他のエラー(エラーコード:"+error.code+")");
          break;
      }
    }
  );
}
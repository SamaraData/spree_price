$(function() {
  var appendParams = function(key, value) {
    var path, url;
    path = window.location.pathname;
    url = Spree.url(path + window.location.search).deleteQueryParam(key).addQueryParam(key, value);
    window.location.href = url.toString();
  };
  
  $('#select_variant_prices_store').on('change', function(event) {
    appendParams('store_id', event.val);
  });
  
  $('#select_variant_prices_price_type').on('change', function(event) {
    appendParams('price_type_id', event.val);
  });
  
  $('#select_variant_prices_role').on('change', function(event) {
    appendParams('role_id', event.val);
  });
});

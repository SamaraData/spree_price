$ ->
  appendParams = (key, value) ->
    path = window.location.pathname;
    url = Spree.url(path + window.location.search).deleteQueryParam(key).addQueryParam(key, value)
    
    window.location.href = url.toString();

  $('#select_variant_prices_store').on 'change', (event) ->
    appendParams('store_id', event.val)
  $('#select_variant_prices_price_type').on 'change', (event) ->
    appendParams('price_type_id', event.val)
  $('#select_variant_prices_role').on 'change', (event) ->
    appendParams('role_id', event.val)
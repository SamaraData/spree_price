$ ->
  class PriceBookVariant
    constructor: (@variant) ->
      @id = @variant.id
      @name = "#{@variant.name} - #{@variant.sku}"
      @price = 0.0

    update: (price) ->
      @price = price

  class PriceBookVariants
    constructor: ->
      @build_select(Spree.url(Spree.routes.variants_api), 'product_name_or_sku_cont')

    format_variant_result: (result) ->
      "#{result.name} - #{result.sku}"

    build_select: (url, query) ->
      $('#price_book_variant').select2
        minimumInputLength: 3
        ajax:
          url: url
          datatype: "json"
          data: (term, page) ->
            query_object = {}
            query_object[query] = term
            q: query_object
            token: Spree.api_key

          results: (data, page) ->
            result = data["variants"]
            window.variants = result
            results: result

        formatResult: @format_variant_result
        formatSelection: (variant) ->
          if !!variant.options_text
            variant.name + " (#{variant.options_text})" + " - #{variant.sku}"
          else
            variant.name + " - #{variant.sku}"

  class PriceBookAddVariants
    constructor: ->
      @variants = []
      if $('#price_book_variant_template').length > 0 
        @template = Handlebars.compile $('#price_book_variant_template').html()

      $('button.price_book_add_variant').click (event) =>
        event.preventDefault()
        if $('#price_book_variant').select2('data')?
          @add_variant()
        else
          alert('Please select a variant first')
      
      $('#price_book-variants-table').on 'click', '.price_book_remove_variant', (event) =>
        event.preventDefault()
        @remove_variant $(event.target)

      $('button.price_book_new_push').click =>
        unless @variants.length > 0
          alert('no variants to transfer')
          false

    add_variant: ->
      variant = $('#price_book_variant').select2('data')
      price = $('#price_book_variant_price').val()

      variant = @find_or_add(variant)
      variant.update(price)
      @render()

    find_or_add: (variant) ->
      if existing = _.find(@variants, (v) -> v.id == variant.id)
        return existing
      else
        variant = new PriceBookVariant($.extend({}, variant))
        @variants.push variant
        return variant

    remove_variant: (target) ->
      variant_id = parseInt(target.data('variantId'))
      @variants = (v for v in @variants when v.id isnt variant_id)
      @render()
    
    clear_variants: ->
      @variants = []
      @render()

    contains: (id) ->
      _.contains(_.pluck(@variants, 'id'), id)

    render: ->
      if @variants.length is 0
        $('#price_book-variants-table').hide()
        $('.no-objects-found').show()
      else
        $('#price_book-variants-table').show()
        $('.no-objects-found').hide()

        rendered = @template { variants: @variants }
        $('#price_book_variants_tbody').html(rendered)

  price_book_add_variants = new PriceBookAddVariants
  price_book_variants = new PriceBookVariants
$(function() {
  var PriceBookAddVariants, PriceBookVariant, PriceBookVariants, price_book_add_variants, price_book_variants;
  PriceBookVariant = class PriceBookVariant {
    constructor(variant1) {
      this.variant = variant1;
      this.id = this.variant.id;
      this.name = `${this.variant.name} - ${this.variant.sku}`;
      this.price = 0.0;
    }

    update(price) {
      return this.price = price;
    }

  };
  PriceBookVariants = class PriceBookVariants {
    constructor() {
      this.build_select(Spree.url(Spree.routes.variants_api), 'product_name_or_sku_cont');
    }

    format_variant_result(result) {
      return `${result.name} - ${result.sku}`;
    }

    build_select(url, query) {
      return $('#price_book_variant').select2({
        minimumInputLength: 3,
        ajax: {
          url: url,
          datatype: "json",
          data: function(term, page) {
            var query_object;
            query_object = {};
            query_object[query] = term;
            return {
              q: query_object,
              token: Spree.api_key
            };
          },
          results: function(data, page) {
            var result;
            result = data["variants"];
            window.variants = result;
            return {
              results: result
            };
          }
        },
        formatResult: this.format_variant_result,
        formatSelection: function(variant) {
          if (!!variant.options_text) {
            return variant.name + ` (${variant.options_text})` + ` - ${variant.sku}`;
          } else {
            return variant.name + ` - ${variant.sku}`;
          }
        }
      });
    }

  };
  PriceBookAddVariants = class PriceBookAddVariants {
    constructor() {
      this.variants = [];
      if ($('#price_book_variant_template').length > 0) {
        this.template = Handlebars.compile($('#price_book_variant_template').html());
      }
      $('button.price_book_add_variant').click((event) => {
        event.preventDefault();
        if ($('#price_book_variant').select2('data') != null) {
          return this.add_variant();
        } else {
          return alert('Please select a variant first');
        }
      });
      $('#price_book-variants-table').on('click', '.price_book_remove_variant', (event) => {
        event.preventDefault();
        return this.remove_variant($(event.target));
      });
      $('button.price_book_new_push').click(() => {
        if (!(this.variants.length > 0)) {
          alert('no variants to transfer');
          return false;
        }
      });
    }

    add_variant() {
      var price, variant;
      variant = $('#price_book_variant').select2('data');
      price = $('#price_book_variant_price').val();
      variant = this.find_or_add(variant);
      variant.update(price);
      return this.render();
    }

    find_or_add(variant) {
      var existing;
      if (existing = _.find(this.variants, function(v) {
        return v.id === variant.id;
      })) {
        return existing;
      } else {
        variant = new PriceBookVariant($.extend({}, variant));
        this.variants.push(variant);
        return variant;
      }
    }

    remove_variant(target) {
      var v, variant_id;
      variant_id = parseInt(target.data('variantId'));
      this.variants = (function() {
        var i, len, ref, results;
        ref = this.variants;
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          v = ref[i];
          if (v.id !== variant_id) {
            results.push(v);
          }
        }
        return results;
      }).call(this);
      return this.render();
    }

    clear_variants() {
      this.variants = [];
      return this.render();
    }

    contains(id) {
      return _.contains(_.pluck(this.variants, 'id'), id);
    }

    render() {
      var rendered;
      if (this.variants.length === 0) {
        $('#price_book-variants-table').hide();
        return $('.no-objects-found').show();
      } else {
        $('#price_book-variants-table').show();
        $('.no-objects-found').hide();
        rendered = this.template({
          variants: this.variants
        });
        return $('#price_book_variants_tbody').html(rendered);
      }
    }

  };
  price_book_add_variants = new PriceBookAddVariants();
  return price_book_variants = new PriceBookVariants();
});

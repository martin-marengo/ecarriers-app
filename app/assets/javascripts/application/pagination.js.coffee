jQuery ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_shipment_publications_url = $('.pagination .next_page a').attr('href')
      if more_shipment_publications_url && $(window).scrollTop() > $(document).height() - $(window).height() - 100
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Cargando..." title="Cargando..." />')
        $.getScript more_shipment_publications_url
      return
    return
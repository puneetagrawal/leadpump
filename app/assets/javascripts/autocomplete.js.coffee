
$(document).ready ->
         $('#test').autocomplete
                 source: "/leads/getemails"
                 select: (event,ui) -> leadSearchFilter(ui.item.id)

         $('#userSearch').autocomplete
                 source: "/company/getemails"
                 select: (event,ui) -> leadSearchFilter(ui.item.id)

$(document).ready ->
         $('#test').autocomplete
                 source: "/leads/getemails"
                 select: (event,ui) -> leadSearchFilter(ui.item.name)

                 

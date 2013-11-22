
$(document).ready ->
         $('#test').autocomplete
                 source: "/leads/getemails"
                 select: (event,ui) -> leadSearchFilter(ui.item.name)

         $('#vipleadlist').autocomplete
                 source: "/searchvipleads"
                 select: (event,ui) -> vipleadSearchFilter(ui.item.name)

                 

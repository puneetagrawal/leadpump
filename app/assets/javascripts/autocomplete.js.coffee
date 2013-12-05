
$(document).ready ->

         $('#test').autocomplete
                 source: "/leads/getemails"
                 select: (event,ui) -> leadSearchFilter(ui.item.name)

         $('#vipleadlist').autocomplete
                 source: "/searchvipleads"
                 select: (event,ui) -> vipleadSearchFilter(ui.item.name)

         $('#searchUserAc').autocomplete
                 source: "/searchUserAc"
                 select: (event,ui) -> userSearchFilter(ui.item.name)

         $('#statsearch').autocomplete
                 source: "/statsearch"
                 select: (event,ui) -> userSearchFilter(ui.item.name)
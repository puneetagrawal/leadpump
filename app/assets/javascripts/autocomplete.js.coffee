
$(document).ready ->
        $('#vipleadlistadmin').autocomplete
                 source: "/searchvipleadsadmin"
                 select: (event,ui) -> vipleadSearchAdminFilter(ui.item.name)

         $('#userlistadmin').autocomplete
                 source: "/searchpaymentadmin"
                 select: (event,ui) -> paymentSearchAdminFilter(ui.item.name)

         $('#test').autocomplete
                 source: "/leads/getemails"
                 select: (event,ui) -> leadSearchFilter(ui.item.name)

         $('#vipleadlist').autocomplete
                 source: "/searchvipleads"
                 select: (event,ui) -> vipleadSearchFilter(ui.item.name)

         $('#searchUserAc').autocomplete
                 source: "/searchUserAc"
                 select: (event,ui) -> userSearchFilter(ui.item.id)

         $('#statsearch').autocomplete
                 source: "/statsearch"
                 select: (event,ui) -> userSearchFilter(ui.item.name)

         $('#optlist').autocomplete
                 source: "/optlist"
                 select: (event,ui) -> optSearchFilter(ui.item.name)

         $('#invitesearch').autocomplete
                source: "/invitelist"
                select: (event,ui) -> invitesearchfilter(ui.item.name)
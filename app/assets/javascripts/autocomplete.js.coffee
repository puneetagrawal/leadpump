
$(document).ready ->
<<<<<<< HEAD
=======
        $('#vipleadlistadmin').autocomplete
                 source: "/searchvipleadsadmin"
                 select: (event,ui) -> vipleadSearchAdminFilter(ui.item.name)
>>>>>>> a18a44c72560384be7706e9deb748a862d41f949

         $('#test').autocomplete
                 source: "/leads/getemails"
                 select: (event,ui) -> leadSearchFilter(ui.item.name)

         $('#vipleadlist').autocomplete
                 source: "/searchvipleads"
                 select: (event,ui) -> vipleadSearchFilter(ui.item.name)

         $('#searchUserAc').autocomplete
                 source: "/searchUserAc"
<<<<<<< HEAD
                 select: (event,ui) -> userSearchFilter(ui.item.name)

         $('#statsearch').autocomplete
                 source: "/statsearch"
=======
>>>>>>> a18a44c72560384be7706e9deb748a862d41f949
                 select: (event,ui) -> userSearchFilter(ui.item.name)
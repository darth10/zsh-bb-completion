(ns fixture-cmds)

(def cmds
  {"backup"
   {:doc "Back up a db"
    :args->opts [:source]
    :spec {:source {:desc "DB URI" :require true}}
    :fn (fn [_])}

   "restore"
   {:doc "Restore a db"
    :args->opts [:source :dest]
    :spec {:source {:desc "Backup URI" :require true}
           :dest {:desc "DB URI" :require true}}
    :fn (fn [_])}})

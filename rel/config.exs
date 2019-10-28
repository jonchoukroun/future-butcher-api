~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Distillery.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"7*$Sb!qBt9ok4C&hqJxGA{fg@1k7z!I$;vr*?yL{r.uVRSaXw{ay_vSpLn4|8y^7"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"T%c)b3)AB28D~%$HB1ul<yGcc6Jc)|o?4_@(syh&f^ouXLGgvlD{arC4&3mz<t?="
  set vm_args: "rel/vm.args"
end

release :future_butcher_api do
  set version: current_version(:future_butcher_api)
  set applications: [
    :runtime_tools
  ]
end

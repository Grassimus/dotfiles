-- DMS user keybind overrides (edit via Control Center or dms; do not remove this header)

hl.unbind("SUPER + space")
hl.bind("SUPER + space", hl.dsp.exec_cmd("dms ipc call spotlight toggle"), { description = "Default Launcher: Toggle" })

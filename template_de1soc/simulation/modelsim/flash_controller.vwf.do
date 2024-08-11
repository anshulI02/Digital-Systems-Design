vlog -work work flash_controller.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.simple_ipod_solution_vlg_vec_tst -voptargs="+acc"
add wave /*
run -all

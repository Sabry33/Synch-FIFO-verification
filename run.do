vlib work
vlog *v +cover -covercells
vsim -voptargs=+acc work.TOP -cover 
add wave *
coverage save TOP.ucdb -onexit
run -all
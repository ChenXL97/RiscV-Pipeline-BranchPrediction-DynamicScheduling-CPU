onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib int_to_float_opt

do {wave.do}

view wave
view structure
view signals

do {int_to_float.udo}

run -all

quit -force

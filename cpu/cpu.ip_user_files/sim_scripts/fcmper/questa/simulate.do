onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fcmper_opt

do {wave.do}

view wave
view structure
view signals

do {fcmper.udo}

run -all

quit -force

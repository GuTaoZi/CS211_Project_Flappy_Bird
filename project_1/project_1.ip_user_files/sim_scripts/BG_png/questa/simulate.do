onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib BG_png_opt

do {wave.do}

view wave
view structure
view signals

do {BG_png.udo}

run -all

quit -force
